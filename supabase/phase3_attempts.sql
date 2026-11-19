-- =====================================================================
-- PHASE 3: attempts + answers, and secure functions for students
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
--
-- KEY IDEA: students NEVER read the questions table directly, because it
-- contains correct_option. They go through the functions below, which
-- return only safe columns and do the grading inside the database.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. ATTEMPTS: one row per (student, quiz). A student gets ONE attempt.
-- ---------------------------------------------------------------------
create table if not exists public.attempts (
  id               uuid primary key default gen_random_uuid(),
  quiz_id          uuid not null references public.quizzes(id) on delete cascade,
  student_id       uuid not null references public.profiles(id) on delete cascade,
  started_at       timestamptz not null default now(),
  submitted_at     timestamptz,           -- null = still in progress
  score            int,                   -- filled in on submit
  total_questions  int,
  unique (quiz_id, student_id)
);

-- ---------------------------------------------------------------------
-- 2. ANSWERS: one row per question in an attempt
-- ---------------------------------------------------------------------
create table if not exists public.answers (
  id               uuid primary key default gen_random_uuid(),
  attempt_id       uuid not null references public.attempts(id) on delete cascade,
  question_id      uuid not null references public.questions(id) on delete cascade,
  selected_option  char(1) check (selected_option in ('A', 'B', 'C', 'D')), -- null = skipped
  is_correct       boolean not null default false,
  unique (attempt_id, question_id)
);

create index if not exists attempts_student_id_idx on public.attempts(student_id);
create index if not exists answers_attempt_id_idx  on public.answers(attempt_id);

-- ---------------------------------------------------------------------
-- 3. Permissions: users may only READ these tables (and only their rows).
--    All writes happen through the functions below.
-- ---------------------------------------------------------------------
grant select on public.attempts to authenticated;
grant select on public.answers  to authenticated;

alter table public.attempts enable row level security;
alter table public.answers  enable row level security;

drop policy if exists "Students view own attempts" on public.attempts;
create policy "Students view own attempts" on public.attempts
  for select to authenticated
  using (student_id = auth.uid());

drop policy if exists "Students view own answers" on public.answers;
create policy "Students view own answers" on public.answers
  for select to authenticated
  using (exists (select 1 from public.attempts a
                 where a.id = answers.attempt_id and a.student_id = auth.uid()));

-- ---------------------------------------------------------------------
-- 4. FUNCTION: list of published quizzes (for the student dashboard)
-- ---------------------------------------------------------------------
create or replace function public.published_quizzes()
returns table (
  id uuid, title text, description text, time_limit_minutes int,
  question_count bigint, teacher_name text
)
language sql stable security definer set search_path = ''
as $$
  select q.id, q.title, q.description, q.time_limit_minutes,
         (select count(*) from public.questions qu where qu.quiz_id = q.id),
         p.full_name
  from public.quizzes q
  join public.profiles p on p.id = q.teacher_id
  where q.is_published and auth.uid() is not null
  order by q.created_at desc;
$$;

-- ---------------------------------------------------------------------
-- 5. FUNCTION: start an attempt (the timer starts NOW, on the server)
--    Calling it again returns the same attempt (no restarting the clock).
-- ---------------------------------------------------------------------
create or replace function public.start_attempt(p_quiz_id uuid)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_attempt_id uuid;
begin
  if not exists (select 1 from public.profiles
                 where id = auth.uid() and role = 'student') then
    raise exception 'Only students can attempt quizzes';
  end if;

  if not exists (select 1 from public.quizzes
                 where id = p_quiz_id and is_published) then
    raise exception 'This quiz is not available';
  end if;

  select id into v_attempt_id from public.attempts
  where quiz_id = p_quiz_id and student_id = auth.uid();

  if v_attempt_id is null then
    insert into public.attempts (quiz_id, student_id)
    values (p_quiz_id, auth.uid())
    returning id into v_attempt_id;
  end if;

  return v_attempt_id;
end;
$$;

-- ---------------------------------------------------------------------
-- 6. FUNCTION: everything the exam page needs, WITHOUT correct answers
--    Returns null if the student hasn't started this quiz.
-- ---------------------------------------------------------------------
create or replace function public.get_attempt_session(p_quiz_id uuid)
returns jsonb
language sql stable security definer set search_path = ''
as $$
  select jsonb_build_object(
    'attempt_id',  a.id,
    'quiz_id',     q.id,
    'quiz_title',  q.title,
    'time_limit_minutes', q.time_limit_minutes,
    'started_at',  a.started_at,
    'deadline',    a.started_at + make_interval(mins => q.time_limit_minutes),
    'server_now',  now(),
    'submitted',   a.submitted_at is not null,
    'questions', case when a.submitted_at is null then coalesce((
        select jsonb_agg(jsonb_build_object(
                 'id', qu.id,
                 'question_text', qu.question_text,
                 'options', jsonb_build_object(
                    'A', qu.option_a, 'B', qu.option_b,
                    'C', qu.option_c, 'D', qu.option_d)
                 -- NOTE: correct_option is deliberately NOT included
               ) order by qu.created_at)
        from public.questions qu where qu.quiz_id = q.id
      ), '[]'::jsonb) else '[]'::jsonb end
  )
  from public.attempts a
  join public.quizzes q on q.id = a.quiz_id
  where a.quiz_id = p_quiz_id and a.student_id = auth.uid();
$$;

-- ---------------------------------------------------------------------
-- 7. FUNCTION: submit + grade (runs entirely on the server)
--    p_answers looks like: {"<question id>": "A", "<question id>": "C"}
-- ---------------------------------------------------------------------
create or replace function public.submit_attempt(p_attempt_id uuid, p_answers jsonb)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_attempt  public.attempts;
  v_deadline timestamptz;
  v_late     boolean;
begin
  -- "for update" locks the row so a double-click can't grade twice
  select * into v_attempt from public.attempts
  where id = p_attempt_id and student_id = auth.uid()
  for update;

  if not found then
    raise exception 'Attempt not found';
  end if;

  if v_attempt.submitted_at is null then
    select v_attempt.started_at + make_interval(mins => q.time_limit_minutes)
      into v_deadline
    from public.quizzes q where q.id = v_attempt.quiz_id;

    -- 30 seconds of grace for slow internet. Later than that = time over,
    -- and the answers sent are ignored (like collecting paper at the bell).
    v_late := now() > v_deadline + interval '30 seconds';

    -- One answer row per question; compare with correct_option here
    insert into public.answers (attempt_id, question_id, selected_option, is_correct)
    select v_attempt.id,
           qu.id,
           s.opt,
           coalesce(s.opt = qu.correct_option, false)
    from public.questions qu
    cross join lateral (
      select case
               when not v_late
                    and coalesce(p_answers ->> qu.id::text, '') in ('A','B','C','D')
               then p_answers ->> qu.id::text
             end as opt
    ) s
    where qu.quiz_id = v_attempt.quiz_id;

    update public.attempts a
    set submitted_at    = now(),
        score           = (select count(*) from public.answers an
                           where an.attempt_id = a.id and an.is_correct),
        total_questions = (select count(*) from public.questions qu
                           where qu.quiz_id = a.quiz_id)
    where a.id = v_attempt.id
    returning * into v_attempt;
  end if;

  return jsonb_build_object(
    'score', v_attempt.score,
    'total', v_attempt.total_questions
  );
end;
$$;

-- ---------------------------------------------------------------------
-- 8. FUNCTION: result + answer review (only AFTER submitting)
-- ---------------------------------------------------------------------
create or replace function public.get_my_result(p_quiz_id uuid)
returns jsonb
language sql stable security definer set search_path = ''
as $$
  select jsonb_build_object(
    'quiz_title',   q.title,
    'score',        a.score,
    'total',        a.total_questions,
    'started_at',   a.started_at,
    'submitted_at', a.submitted_at,
    'questions', coalesce((
      select jsonb_agg(jsonb_build_object(
               'question_text',   qu.question_text,
               'options', jsonb_build_object(
                  'A', qu.option_a, 'B', qu.option_b,
                  'C', qu.option_c, 'D', qu.option_d),
               'correct_option',  qu.correct_option,
               'selected_option', an.selected_option,
               'is_correct',      an.is_correct
             ) order by qu.created_at)
      from public.answers an
      join public.questions qu on qu.id = an.question_id
      where an.attempt_id = a.id
    ), '[]'::jsonb)
  )
  from public.attempts a
  join public.quizzes q on q.id = a.quiz_id
  where a.quiz_id = p_quiz_id
    and a.student_id = auth.uid()
    and a.submitted_at is not null;
$$;

-- ---------------------------------------------------------------------
-- 9. Only logged-in users may call these functions
-- ---------------------------------------------------------------------
revoke execute on function public.published_quizzes()               from public, anon;
revoke execute on function public.start_attempt(uuid)               from public, anon;
revoke execute on function public.get_attempt_session(uuid)         from public, anon;
revoke execute on function public.submit_attempt(uuid, jsonb)       from public, anon;
revoke execute on function public.get_my_result(uuid)               from public, anon;

grant execute on function public.published_quizzes()                to authenticated;
grant execute on function public.start_attempt(uuid)                to authenticated;
grant execute on function public.get_attempt_session(uuid)          to authenticated;
grant execute on function public.submit_attempt(uuid, jsonb)        to authenticated;
grant execute on function public.get_my_result(uuid)                to authenticated;

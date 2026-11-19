-- =====================================================================
-- PHASE 4: teacher results + lock questions after students attempt
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. FUNCTION: all attempts for one quiz (only the quiz owner can see)
-- ---------------------------------------------------------------------
create or replace function public.quiz_results(p_quiz_id uuid)
returns table (
  attempt_id      uuid,
  student_name    text,
  student_email   text,
  started_at      timestamptz,
  submitted_at    timestamptz,
  score           int,
  total_questions int
)
language sql stable security definer set search_path = ''
as $$
  select a.id, p.full_name, u.email::text,
         a.started_at, a.submitted_at, a.score, a.total_questions
  from public.attempts a
  join public.quizzes  q on q.id = a.quiz_id
  join public.profiles p on p.id = a.student_id
  join auth.users      u on u.id = a.student_id
  where a.quiz_id = p_quiz_id
    and q.teacher_id = auth.uid()          -- <- only the owner teacher
  order by a.score desc nulls last, a.submitted_at;
$$;

-- ---------------------------------------------------------------------
-- 2. FUNCTION: per-question statistics (which questions were hardest?)
-- ---------------------------------------------------------------------
create or replace function public.question_stats(p_quiz_id uuid)
returns table (
  question_id    uuid,
  question_text  text,
  correct_option text,
  responses      bigint,
  correct        bigint,
  picked_a       bigint,
  picked_b       bigint,
  picked_c       bigint,
  picked_d       bigint,
  skipped        bigint
)
language sql stable security definer set search_path = ''
as $$
  select qu.id, qu.question_text, qu.correct_option::text,
         count(an.id),
         count(*) filter (where an.is_correct),
         count(*) filter (where an.selected_option = 'A'),
         count(*) filter (where an.selected_option = 'B'),
         count(*) filter (where an.selected_option = 'C'),
         count(*) filter (where an.selected_option = 'D'),
         count(*) filter (where an.id is not null and an.selected_option is null)
  from public.questions qu
  join public.quizzes q on q.id = qu.quiz_id
  left join public.answers an on an.question_id = qu.id
  where qu.quiz_id = p_quiz_id
    and q.teacher_id = auth.uid()
  group by qu.id, qu.question_text, qu.correct_option, qu.created_at
  order by qu.created_at;
$$;

-- ---------------------------------------------------------------------
-- 3. FUNCTION: one student's full answer sheet (for the quiz owner)
-- ---------------------------------------------------------------------
create or replace function public.attempt_detail(p_attempt_id uuid)
returns jsonb
language sql stable security definer set search_path = ''
as $$
  select jsonb_build_object(
    'quiz_id',       q.id,
    'quiz_title',    q.title,
    'student_name',  p.full_name,
    'student_email', u.email,
    'score',         a.score,
    'total',         a.total_questions,
    'started_at',    a.started_at,
    'submitted_at',  a.submitted_at,
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
  join public.quizzes  q on q.id = a.quiz_id
  join public.profiles p on p.id = a.student_id
  join auth.users      u on u.id = a.student_id
  where a.id = p_attempt_id
    and q.teacher_id = auth.uid();
$$;

revoke execute on function public.quiz_results(uuid)   from public, anon;
revoke execute on function public.question_stats(uuid) from public, anon;
revoke execute on function public.attempt_detail(uuid) from public, anon;
grant  execute on function public.quiz_results(uuid)   to authenticated;
grant  execute on function public.question_stats(uuid) to authenticated;
grant  execute on function public.attempt_detail(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 4. TRIGGER: once any student has attempted a quiz, its questions are
--    frozen. Otherwise old scores would no longer match the questions.
--    (Deleting the WHOLE quiz is still allowed: it removes everything.)
-- ---------------------------------------------------------------------
create or replace function public.lock_questions_after_attempts()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  if tg_op in ('UPDATE', 'DELETE') then
    -- "quiz still exists" check lets a full quiz delete cascade normally
    if exists (select 1 from public.quizzes  where id = old.quiz_id)
       and exists (select 1 from public.attempts where quiz_id = old.quiz_id) then
      raise exception 'Students have already attempted this quiz, so its questions can no longer be changed.';
    end if;
  end if;

  if tg_op in ('INSERT', 'UPDATE') then
    if exists (select 1 from public.attempts where quiz_id = new.quiz_id) then
      raise exception 'Students have already attempted this quiz, so its questions can no longer be changed.';
    end if;
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

drop trigger if exists questions_lock_after_attempts on public.questions;
create trigger questions_lock_after_attempts
  before insert or update or delete on public.questions
  for each row execute function public.lock_questions_after_attempts();

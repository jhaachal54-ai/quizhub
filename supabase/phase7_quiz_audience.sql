-- =====================================================================
-- PHASE 7: every teacher quiz is for ONE class/course + ONE subject.
-- Students only see (and can only start) quizzes meant for them.
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. New "audience" columns on quizzes
-- ---------------------------------------------------------------------
alter table public.quizzes
  add column if not exists subject text,
  add column if not exists target_education_type text
      check (target_education_type in ('school', 'college')),
  add column if not exists target_standard int
      check (target_standard between 1 and 12),
  add column if not exists target_course text
      check (target_course in ('BCA')),
  add column if not exists target_college_year int      -- null = all years
      check (target_college_year between 1 and 3);

-- Old quizzes have no audience yet -> take them offline until the teacher
-- sets one (their results are kept).
update public.quizzes set is_published = false
where is_published and subject is null;

-- Audience must be complete and consistent; published quizzes MUST have one.
alter table public.quizzes drop constraint if exists quizzes_audience_valid;
alter table public.quizzes add constraint quizzes_audience_valid check (
  (subject is null and target_education_type is null and target_standard is null
     and target_course is null and target_college_year is null and not is_published)
  or (target_education_type = 'school' and target_standard is not null
      and target_course is null and target_college_year is null
      and subject in ('gk','current_affairs','maths','science','physics','chemistry','biology'))
  or (target_education_type = 'college' and target_course is not null
      and target_standard is null
      and subject in ('gk','current_affairs','maths','dbms','java','oops','cpp','cloud','ebusiness','dccn'))
);

-- ---------------------------------------------------------------------
-- 2. Helper: is this quiz meant for the logged-in student?
-- ---------------------------------------------------------------------
create or replace function public.quiz_is_for_me(p_quiz_id uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1
    from public.quizzes q
    join public.profiles me on me.id = auth.uid()
    where q.id = p_quiz_id
      and q.is_published
      and (
        (q.target_education_type = 'school'
          and me.education_type = 'school'
          and q.target_standard = me.standard)
        or
        (q.target_education_type = 'college'
          and me.education_type = 'college'
          and q.target_course = me.course
          and (q.target_college_year is null or q.target_college_year = me.college_year))
      )
  );
$$;

revoke execute on function public.quiz_is_for_me(uuid) from public, anon;
grant  execute on function public.quiz_is_for_me(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 3. Student quiz list: now filtered to the student's class/course.
--    (Return columns changed, so the old function must be dropped first.)
-- ---------------------------------------------------------------------
drop function if exists public.published_quizzes();

create function public.published_quizzes()
returns table (
  id uuid, title text, description text, time_limit_minutes int,
  question_count bigint, teacher_name text, subject text
)
language sql stable security definer set search_path = ''
as $$
  select q.id, q.title, q.description, q.time_limit_minutes,
         (select count(*) from public.questions qu where qu.quiz_id = q.id),
         p.full_name,
         q.subject
  from public.quizzes q
  join public.profiles p on p.id = q.teacher_id
  where public.quiz_is_for_me(q.id)
  order by q.created_at desc;
$$;

revoke execute on function public.published_quizzes() from public, anon;
grant  execute on function public.published_quizzes() to authenticated;

-- ---------------------------------------------------------------------
-- 4. start_attempt: refuse quizzes that are not for this student
--    (stops someone starting another class's quiz by guessing its id)
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

  -- Already started earlier? Return the same attempt (timer keeps running)
  select id into v_attempt_id from public.attempts
  where quiz_id = p_quiz_id and student_id = auth.uid();
  if v_attempt_id is not null then
    return v_attempt_id;
  end if;

  if not public.quiz_is_for_me(p_quiz_id) then
    raise exception 'This quiz is not available for your class';
  end if;

  insert into public.attempts (quiz_id, student_id)
  values (p_quiz_id, auth.uid())
  returning id into v_attempt_id;

  return v_attempt_id;
end;
$$;

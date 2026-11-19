-- =====================================================================
-- PHASE 6: self-practice library (no teacher needed)
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- THEN run the 3 seed files (seed_school_1_8.sql, seed_school_9_12.sql,
-- seed_bca.sql) to fill in the questions.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Question bank. Each question is for a RANGE of school standards
--    (e.g. 3 to 5) or for a college course (all years of BCA).
-- ---------------------------------------------------------------------
create table if not exists public.practice_questions (
  id              uuid primary key default gen_random_uuid(),
  subject         text not null,
  education_type  text not null check (education_type in ('school', 'college')),
  min_standard    int  check (min_standard between 1 and 12),
  max_standard    int  check (max_standard between 1 and 12),
  course          text,
  question_text   text not null,
  option_a        text not null,
  option_b        text not null,
  option_c        text not null,
  option_d        text not null,
  correct_option  char(1) not null check (correct_option in ('A', 'B', 'C', 'D')),
  explanation     text not null default '',
  created_at      timestamptz not null default now(),
  constraint practice_level_valid check (
    (education_type = 'school'  and min_standard is not null and max_standard is not null
                                and min_standard <= max_standard and course is null)
    or
    (education_type = 'college' and course is not null
                                and min_standard is null and max_standard is null)
  )
);

create index if not exists practice_questions_lookup_idx
  on public.practice_questions (subject, education_type, course, min_standard, max_standard);

-- ---------------------------------------------------------------------
-- 2. Practice history: one row per finished practice round
-- ---------------------------------------------------------------------
create table if not exists public.practice_attempts (
  id          uuid primary key default gen_random_uuid(),
  student_id  uuid not null references public.profiles(id) on delete cascade,
  subject     text not null,
  score       int  not null check (score >= 0),
  total       int  not null check (total > 0 and score <= total),
  created_at  timestamptz not null default now()
);

create index if not exists practice_attempts_student_idx
  on public.practice_attempts (student_id, subject);

-- ---------------------------------------------------------------------
-- 3. Permissions
--    - Practice questions are a public learning library: any logged-in
--      user may READ them (answers included: it's practice, not an exam).
--    - Only the database admin adds questions (via the seed files).
--    - Students insert/read only their OWN practice history.
-- ---------------------------------------------------------------------
grant select on public.practice_questions to authenticated;
grant select, insert on public.practice_attempts to authenticated;

alter table public.practice_questions enable row level security;
alter table public.practice_attempts  enable row level security;

drop policy if exists "Logged-in users read practice questions" on public.practice_questions;
create policy "Logged-in users read practice questions" on public.practice_questions
  for select to authenticated
  using (true);

drop policy if exists "Students read own practice" on public.practice_attempts;
create policy "Students read own practice" on public.practice_attempts
  for select to authenticated
  using (student_id = auth.uid());

drop policy if exists "Students save own practice" on public.practice_attempts;
create policy "Students save own practice" on public.practice_attempts
  for insert to authenticated
  with check (student_id = auth.uid());

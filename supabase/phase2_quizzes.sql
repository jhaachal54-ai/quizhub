-- =====================================================================
-- PHASE 2: quizzes + questions tables
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. QUIZZES: one row per quiz, owned by a teacher
-- ---------------------------------------------------------------------
create table if not exists public.quizzes (
  id                  uuid primary key default gen_random_uuid(),
  teacher_id          uuid not null references public.profiles(id) on delete cascade,
  title               text not null check (char_length(title) between 1 and 200),
  description         text not null default '',
  time_limit_minutes  int  not null check (time_limit_minutes between 1 and 300),
  is_published        boolean not null default false,
  created_at          timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 2. QUESTIONS: MCQ with exactly 4 options and 1 correct answer
-- ---------------------------------------------------------------------
create table if not exists public.questions (
  id              uuid primary key default gen_random_uuid(),
  quiz_id         uuid not null references public.quizzes(id) on delete cascade,
  question_text   text not null check (char_length(question_text) > 0),
  option_a        text not null,
  option_b        text not null,
  option_c        text not null,
  option_d        text not null,
  correct_option  char(1) not null check (correct_option in ('A', 'B', 'C', 'D')),
  created_at      timestamptz not null default now()
);

-- Index = faster "get all questions of this quiz"
create index if not exists questions_quiz_id_idx on public.questions(quiz_id);
create index if not exists quizzes_teacher_id_idx on public.quizzes(teacher_id);

-- ---------------------------------------------------------------------
-- 3. Table permissions (GRANT). Needed in new Supabase projects.
--    RLS below still decides WHICH rows each user can touch.
-- ---------------------------------------------------------------------
grant select, insert, update, delete on public.quizzes   to authenticated;
grant select, insert, update, delete on public.questions to authenticated;

alter table public.quizzes   enable row level security;
alter table public.questions enable row level security;

-- ---------------------------------------------------------------------
-- 4. Helper: is the logged-in user a teacher?
--    "security definer" lets it read profiles regardless of RLS.
-- ---------------------------------------------------------------------
create or replace function public.is_teacher()
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'teacher'
  );
$$;

-- ---------------------------------------------------------------------
-- 5. RLS policies for QUIZZES (teacher manages only their own)
-- ---------------------------------------------------------------------
drop policy if exists "Teachers view own quizzes"   on public.quizzes;
drop policy if exists "Teachers create quizzes"     on public.quizzes;
drop policy if exists "Teachers update own quizzes" on public.quizzes;
drop policy if exists "Teachers delete own quizzes" on public.quizzes;

create policy "Teachers view own quizzes" on public.quizzes
  for select to authenticated
  using (teacher_id = auth.uid());

create policy "Teachers create quizzes" on public.quizzes
  for insert to authenticated
  with check (teacher_id = auth.uid() and public.is_teacher());

create policy "Teachers update own quizzes" on public.quizzes
  for update to authenticated
  using (teacher_id = auth.uid())
  with check (teacher_id = auth.uid());

create policy "Teachers delete own quizzes" on public.quizzes
  for delete to authenticated
  using (teacher_id = auth.uid());

-- ---------------------------------------------------------------------
-- 6. RLS policies for QUESTIONS
--    A teacher can manage a question only if they own its quiz.
-- ---------------------------------------------------------------------
drop policy if exists "Teachers manage questions of own quizzes" on public.questions;

create policy "Teachers manage questions of own quizzes" on public.questions
  for all to authenticated
  using (
    exists (select 1 from public.quizzes q
            where q.id = questions.quiz_id and q.teacher_id = auth.uid())
  )
  with check (
    exists (select 1 from public.quizzes q
            where q.id = questions.quiz_id and q.teacher_id = auth.uid())
  );

-- (Student access to published quizzes is added in Phase 3, in a way
--  that never sends the correct answers to the browser.)

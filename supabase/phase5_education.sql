-- =====================================================================
-- PHASE 5: student education details (school standard / college course)
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. New columns on profiles (null for teachers)
-- ---------------------------------------------------------------------
alter table public.profiles
  add column if not exists education_type text
      check (education_type in ('school', 'college')),
  add column if not exists standard int
      check (standard between 1 and 12),
  add column if not exists course text
      check (course in ('BCA')),          -- add more courses here later
  add column if not exists college_year int
      check (college_year between 1 and 3);

-- A row must be EITHER school (with standard) OR college (with course + year)
alter table public.profiles drop constraint if exists profiles_education_valid;
alter table public.profiles add constraint profiles_education_valid check (
  education_type is null
  or (education_type = 'school'
      and standard is not null and course is null and college_year is null)
  or (education_type = 'college'
      and course is not null and college_year is not null and standard is null)
);

-- ---------------------------------------------------------------------
-- 2. Users may edit ONLY these columns of their OWN profile.
--    "role" is not in the list, so nobody can promote themselves.
-- ---------------------------------------------------------------------
grant update (full_name, education_type, standard, course, college_year)
  on public.profiles to authenticated;

drop policy if exists "Users update own profile" on public.profiles;
create policy "Users update own profile" on public.profiles
  for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------------------------------------------------------------------
-- 3. Signup trigger now also copies the education details
-- ---------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
declare
  meta     jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_role   text  := case when meta ->> 'role' = 'teacher' then 'teacher' else 'student' end;
  v_type   text;
  v_std    int;
  v_course text;
  v_year   int;
begin
  if v_role = 'student' then
    if meta ->> 'education_type' = 'school'
       and coalesce(meta ->> 'standard', '') ~ '^([1-9]|1[0-2])$' then
      v_type := 'school';
      v_std  := (meta ->> 'standard')::int;
    elsif meta ->> 'education_type' = 'college'
       and meta ->> 'course' = 'BCA'
       and coalesce(meta ->> 'college_year', '') ~ '^[1-3]$' then
      v_type   := 'college';
      v_course := 'BCA';
      v_year   := (meta ->> 'college_year')::int;
    end if;
    -- anything invalid -> left empty; the app asks the student to fill it in
  end if;

  insert into public.profiles (id, full_name, role, education_type, standard, course, college_year)
  values (new.id, coalesce(meta ->> 'full_name', ''), v_role, v_type, v_std, v_course, v_year);

  return new;
end;
$$;

-- =====================================================================
-- PHASE 1: profiles table
-- Paste this whole file into Supabase -> SQL Editor -> New query -> Run
-- =====================================================================

-- 1. One row per user. "id" is the same id as in Supabase's auth.users.
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null default '',
  role        text not null check (role in ('teacher', 'student')),
  created_at  timestamptz not null default now()
);

-- 2. Turn on Row Level Security (RLS).
--    With RLS on, NOBODY can read/write rows unless a policy allows it.
alter table public.profiles enable row level security;

-- 3. Policy: a logged-in user can read ONLY their own profile.
drop policy if exists "Users can view own profile" on public.profiles;
create policy "Users can view own profile"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);

-- (No insert/update policy on purpose: profiles are created by the trigger
--  below, and users cannot change their own role from the browser.)

-- 3b. Table-level permission. New Supabase projects do NOT automatically
--     let the API roles touch tables created in SQL. Logged-in users
--     ("authenticated") may SELECT; RLS above still limits them to their own row.
grant select on public.profiles to authenticated;

-- 4. Trigger function: runs automatically when someone signs up.
--    It copies full_name + role from the signup form into profiles.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    case
      when new.raw_user_meta_data ->> 'role' = 'teacher' then 'teacher'
      else 'student'   -- anything else (or missing) becomes student
    end
  );
  return new;
end;
$$;

-- 5. Attach the function to the auth.users table.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

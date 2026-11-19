# Phase 1: Project Setup + Login/Signup with Roles

## What we built
- A Next.js app (App Router) styled with Tailwind CSS.
- Signup page: name, email, password, and a choice of **Student** or **Teacher**.
- Login page: email + password.
- `/dashboard` sends teachers to `/teacher` and students to `/student`.
- Log out button.
- A `profiles` table in Supabase that stores each user's name and role.

## File map
| File | What it does |
|---|---|
| `app/layout.js` | Wraps every page (loads Tailwind CSS) |
| `app/page.js` | Home page with Log in / Sign up buttons |
| `app/signup/page.js` | Signup form, calls `supabase.auth.signUp()` |
| `app/login/page.js` | Login form, calls `supabase.auth.signInWithPassword()` |
| `app/dashboard/page.js` | Reads the role and redirects to the right dashboard |
| `app/teacher/page.js`, `app/student/page.js` | Role-protected dashboards |
| `app/auth/signout/route.js` | API route that logs the user out |
| `lib/supabase/client.js` | Supabase connection used in the browser |
| `lib/supabase/server.js` | Supabase connection used on the server (reads cookies) |
| `lib/auth.js` | `getCurrentUser()` and `requireRole()` helpers |
| `middleware.js` | Runs before every request: refreshes the session, blocks logged-out users |
| `supabase/phase1_profiles.sql` | Creates the `profiles` table, security rules, and signup trigger |

## How signup works (step by step)
1. The student fills the form and clicks **Sign up**.
2. The browser calls `supabase.auth.signUp()` with email/password, plus `full_name` and `role` as *metadata*.
3. Supabase creates a row in its built-in `auth.users` table.
4. Our **database trigger** `on_auth_user_created` fires automatically and inserts a row in `public.profiles` with the same `id`, the name and the role.
5. Supabase returns a session. The session is stored in **cookies**, so the user stays logged in.
6. We redirect to `/dashboard`, which reads the role from `profiles` and sends the user to `/teacher` or `/student`.

## Likely viva questions
**Q: Why a separate `profiles` table? Doesn't Supabase already store users?**
Supabase keeps login data (email, password hash) in `auth.users`, a private schema we shouldn't change. App-specific data such as the name and role goes in our own `profiles` table, linked by the same `id` (one-to-one relationship, foreign key with `on delete cascade`).

**Q: What is a trigger?**
A function the database runs automatically when something happens. Ours runs *after insert* on `auth.users`, so every new user gets a profile row without any extra code in the frontend.

**Q: What is Row Level Security (RLS)?**
A Postgres feature that filters rows per user. Once RLS is on, no rows are visible unless a policy allows it. Our policy `auth.uid() = id` means a user can only read their own profile. This matters because the anon key is public: anyone can see it in the browser, so security has to live in the database.

**Q: What is the difference between GRANT and RLS?**
Two layers of security. `GRANT` decides whether a role (like `authenticated`) may touch the *table at all*. RLS policies then decide *which rows* it can see. We hit error `42501 permission denied for table profiles` because RLS was set up but the GRANT was missing. Fix: `grant select on public.profiles to authenticated;`

**Q: Can a student make themselves a teacher?**
There is no UPDATE policy on `profiles`, so users can't change their role from the browser. The trigger also only accepts `'teacher'` or `'student'` (anything else becomes student), and the table has a `CHECK` constraint. (Limitation: anyone can pick "Teacher" at signup. A real college system would need admin approval. Mention this as future scope.)

**Q: What does middleware do?**
It runs on the server before every page loads. It refreshes the Supabase session cookie and redirects logged-out users away from `/teacher`, `/student` and `/dashboard`.

**Q: How do you stop a student from opening `/teacher`?**
`requireRole("teacher")` runs on the server, reads the profile, and redirects anyone whose role isn't teacher. Because it runs on the server, hiding links isn't the only protection.

**Q: Server Component vs Client Component?**
Login and signup forms are Client Components (`"use client"`) because they need state (`useState`) and button clicks. The dashboards are Server Components: they run on the server, fetch the profile securely, and send ready HTML to the browser.

**Q: Why two Supabase clients?**
`client.js` runs in the browser. `server.js` runs on the server and reads the login session from the request cookies. Both use the same URL and public anon key.

**Q: Where are the keys stored?**
In `.env.local`, which is ignored by git. Variables starting with `NEXT_PUBLIC_` are allowed in the browser. The anon key is safe to expose because RLS protects the data. The `service_role` key must **never** go in frontend code.

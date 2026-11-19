# QuizHub: Online Quiz / Exam Platform

A final-year project: an online exam platform where **teachers** create timed MCQ quizzes for a specific class and subject, and **students** attempt them and get their score instantly. Students can also practise on their own with a built-in question bank.

🔗 **Live demo:** https://quizhub-livid.vercel.app

**Tech stack:** Next.js 15 (App Router) · Supabase (PostgreSQL, Auth, Row Level Security) · Tailwind CSS · Vercel

## Features
**Teacher**
- Create quizzes with a time limit, targeted to a class (1–12) or a course and year (BCA), and a subject
- Add MCQ questions (4 options, 1 correct), then publish or unpublish
- Results: class average, highest and lowest score, ranked student list, per-question analysis, CSV export
- Questions lock automatically once students have attempted the quiz

**Student**
- Sign up as school (standard 1–12) or college (BCA, year 1–3)
- See only the quizzes meant for their class
- Timed exam with a server-side timer and auto-submit, one attempt per quiz
- Instant score with an answer review
- Self-practice library: 272 questions across 15 subjects, with explanations and unlimited rounds

## Security highlights
- Row Level Security on every table, plus explicit GRANTs
- Correct answers are never sent to the browser during exams; grading happens inside PostgreSQL functions
- The exam timer is enforced by the database (start time stored on the server)
- Users can't change their own role (column-level GRANT)

## Run locally
```bash
npm install
cp .env.local.example .env.local   # then paste your Supabase URL + anon key
npm run dev
```
Database setup: run the files in `supabase/` in order (phase1 → phase7, then the three seed files) in the Supabase SQL Editor.

Phase-by-phase design notes are in `docs/`.

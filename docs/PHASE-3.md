# Phase 3: Students Attempt Quizzes (Timer + Instant Score)

## What we built
- **Student dashboard** (`/student`): published quizzes with a **Start quiz**, **Continue** or **Score: x/y** button.
- **Exam page** (`/student/quizzes/[id]/attempt`): all questions, a live **countdown timer**, an answered counter, and a **Submit** button. It **auto-submits** at 00:00.
- **Result page** (`/student/quizzes/[id]/result`): score, percentage, correct/wrong/skipped counts, time taken, and a review of every question.
- Two new tables: `attempts` and `answers`.

## Database design
```
profiles ──< attempts >── quizzes ──< questions
               │                         │
               └──────< answers >────────┘
```
- `attempts`: one row per student per quiz. `unique (quiz_id, student_id)` enforces **one attempt only**.
  `submitted_at = null` means the attempt is in progress. `score` and `total_questions` are filled in on submit.
- `answers`: one row per question in an attempt. It stores `selected_option` (null means skipped) and `is_correct`.

## The most important design decision: protecting the answers
The `questions` table contains `correct_option`. If students could read it, anyone could open the browser DevTools and see the answers.
So **students have no access to `questions` at all**. They use 5 database functions instead:

| Function | What it does |
|---|---|
| `published_quizzes()` | List of published quizzes with question count + teacher name |
| `start_attempt(quiz)` | Creates the attempt and **records the start time on the server** |
| `get_attempt_session(quiz)` | Questions + options + deadline, **without `correct_option`** |
| `submit_attempt(attempt, answers)` | Saves the answers, **grades them inside the database**, stores the score |
| `get_my_result(quiz)` | Score + review with correct answers, **only after submitting** |

These are `security definer` functions: they run with the owner's rights, so they can read `questions`. Each one checks `auth.uid()` first, so a student only ever gets *their own* data.

## Timer: why it can't be cheated
- The **start time is saved on the server** (`started_at default now()`), not taken from the student's computer.
- Deadline = `started_at + time_limit_minutes`.
- The browser only *displays* the countdown. It also corrects for a wrong PC clock using `server_now`.
- On submit, the database checks the time again. More than **30 seconds late** (grace period for slow internet) means the answers are ignored.
- If a student closes the tab and comes back after the deadline, the attempt is closed automatically.
- Refreshing the page **doesn't reset the timer**, because the start time is stored in the database. Answers are kept in the browser's `localStorage`, so a refresh doesn't lose them.

## File map
| File | What it does |
|---|---|
| `supabase/phase3_attempts.sql` | Tables, RLS, and the 5 functions |
| `app/student/layout.js` | Navbar + student-only check for all `/student` pages |
| `app/student/page.js` | Quiz list with Start / Continue / Score |
| `app/student/quizzes/actions.js` | `startQuiz`, `submitQuiz` Server Actions |
| `app/student/quizzes/[id]/attempt/page.js` | Server part: loads the session, handles expired attempts |
| `app/student/quizzes/[id]/attempt/QuizRunner.js` | Client part: timer, answer buttons, submit |
| `app/student/quizzes/[id]/result/page.js` | Score card + answer review |

## Likely viva questions
**Q: Where is the score calculated? Why not in JavaScript?**
Inside the database, in `submit_attempt`. If grading happened in the browser, the browser would need the correct answers, and a student could change their score. The server never trusts the client.

**Q: How do you stop a student taking the quiz twice?**
With `unique (quiz_id, student_id)` on `attempts`. Also, `start_attempt` returns the existing attempt instead of creating a new one, and `submit_attempt` does nothing if the attempt is already submitted.

**Q: What if the student double-clicks Submit?**
`select ... for update` locks the attempt row, so the second call waits and then sees `submitted_at` is already set. The button is also disabled while submitting.

**Q: What does `security definer` mean? Isn't it dangerous?**
The function runs with its creator's permissions instead of the caller's. It's safe here because each function filters on `auth.uid()` (the logged-in user) and returns only safe columns. `set search_path = ''` prevents a known attack where someone creates fake tables with the same names.

**Q: Why is part of the exam page a Server Component and part a Client Component?**
The server part checks the role, loads the questions securely, and handles expired attempts. The client part (`"use client"`) needs things only a browser has: a ticking timer (`setInterval`), clicks, `useState`, and `localStorage`.

**Q: What is `jsonb`?**
A JSON data type in PostgreSQL. `get_attempt_session` builds the whole response (quiz + questions + deadline) as one JSON object, so the page needs only one request.

**Q: What is the clock offset for?**
If a student's PC clock is 5 minutes wrong, a timer based on their clock would be wrong too. We compute `offset = server_now - Date.now()` and add it, so the countdown follows the server's clock.

**Q: Limitations / future scope?**
- Answers are saved in the browser until submit. Saving each answer to the server would survive switching devices.
- Shuffling the order of questions and options would make copying harder.
- Tab-switch detection for proctoring.

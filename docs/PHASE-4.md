# Phase 4: Teacher Views Results

## What we built
- **View results (N)** button on every quiz in the teacher's editor.
- **Results page** (`/teacher/quizzes/[id]/results`):
  - Summary cards: students submitted, class average, highest, lowest.
  - Student table, ranked by score, with name, email, score, % and submit time. Students still taking the quiz show "In progress".
  - **Question analysis**: for each question, how many got it right (a coloured bar), and how many picked A, B, C or D. This shows which questions were hardest and which wrong option was the most common.
  - **Download CSV** to open the results in Excel.
- **Student answer sheet** (`/teacher/quizzes/[id]/results/[attemptId]`): the same review screen the student sees.
- **Question lock**: once any student has attempted a quiz, its questions can't be added, edited or deleted. This is enforced by a **database trigger**.

## New database objects (`supabase/phase4_results.sql`)
| Object | Type | Purpose |
|---|---|---|
| `quiz_results(quiz)` | function | All attempts of a quiz + student name/email |
| `question_stats(quiz)` | function | Per-question counts using `count(*) filter (...)` and `group by` |
| `attempt_detail(attempt)` | function | One student's full answer sheet as JSON |
| `lock_questions_after_attempts` | trigger | Blocks question changes once attempts exist |

Every function has `where q.teacher_id = auth.uid()`, so a teacher can only see results for **their own** quizzes.

## Likely viva questions
**Q: How does a teacher see student names when RLS lets users read only their own profile?**
Through `security definer` functions that join `attempts`, `profiles` and `auth.users`. The function runs with the owner's rights but filters on `q.teacher_id = auth.uid()`, so it returns only students who attempted *this teacher's* quiz. We didn't open up the `profiles` table to everyone.

**Q: Where does the email come from?**
From Supabase's private `auth.users` table. The browser can't read it directly. Only our server-side function can, and only for the teacher's own students.

**Q: Explain `count(*) filter (where ...)`.**
It counts only the rows matching the condition. In one pass over the answers we get the total responses, the correct count, and the count of each option picked (A/B/C/D), grouped by question.

**Q: Why lock questions after students attempt?**
Scores are stored at submit time. If the teacher later changed the correct answer or deleted a question, old scores wouldn't match the questions any more, and the results would be unfair or wrong.

**Q: Why a trigger instead of checking in the Next.js code?**
A trigger runs **inside the database on every change**, no matter where the change comes from: our app, the Supabase dashboard, or a direct API call. App-side checks can be bypassed; the database can't. We check in both places: the UI hides the buttons, and the trigger is the real guarantee.

**Q: Can the teacher still delete the quiz?**
Yes. The trigger checks "does the quiz still exist?". During a full quiz delete the quiz row is already gone, so the cascade can remove its questions, attempts and answers together. The confirm popup warns that the results will be deleted.

**Q: How is the class average calculated?**
Each submitted student's percentage (`score / total × 100`) is averaged. Students still in progress aren't counted.

**Q: How does the CSV download work without a server?**
`ExportCsvButton` is a Client Component. It builds the CSV text in the browser, wraps it in a `Blob`, and clicks a temporary download link. Values are quoted so commas in names don't break the columns.

**Q: What does `Promise.all` do on the results page?**
It runs the `quiz_results` and `question_stats` queries **at the same time** instead of one after the other, so the page loads faster.

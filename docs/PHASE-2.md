# Phase 2: Teacher Creates Quizzes & Questions

## What we built
- Two new tables: `quizzes` and `questions`.
- **My Quizzes** page (`/teacher`): cards showing each quiz with its question count, time limit and Draft/Published badge.
- **New Quiz** page (`/teacher/quizzes/new`): title, description, time limit.
- **Quiz Editor** (`/teacher/quizzes/[id]`): edit details, add MCQ questions (4 options + pick the correct one), delete questions, publish/unpublish, delete the quiz.

## Database design
```
profiles (1) ──< quizzes (many) ──< questions (many)
   id            id, teacher_id       id, quiz_id
                 title, description   question_text
                 time_limit_minutes   option_a..option_d
                 is_published         correct_option ('A'..'D')
```
- `quizzes.teacher_id` → `profiles.id` (foreign key). One teacher has many quizzes.
- `questions.quiz_id` → `quizzes.id` (foreign key). One quiz has many questions.
- `ON DELETE CASCADE`: deleting a quiz deletes its questions automatically.
- `CHECK` constraints: the time limit must be 1–300, and `correct_option` must be A, B, C or D. The database rejects bad data even if the UI has a bug.

## File map
| File | What it does |
|---|---|
| `supabase/phase2_quizzes.sql` | Tables, indexes, GRANTs, `is_teacher()` function, RLS policies |
| `app/teacher/layout.js` | Shared navbar + role check for every `/teacher/...` page |
| `app/teacher/page.js` | Lists the teacher's quizzes |
| `app/teacher/quizzes/new/page.js` | Create-quiz form |
| `app/teacher/quizzes/[id]/page.js` | Quiz editor |
| `app/teacher/quizzes/actions.js` | **Server Actions**: createQuiz, updateQuizDetails, setPublished, deleteQuiz, addQuestion, deleteQuestion |
| `components/SubmitButton.js` | Button that shows "Saving..." and can ask "Are you sure?" |
| `components/QuizDetailsFields.js` | Reused title/description/time inputs |
| `components/Alert.js` | Red/green message box |

## Business rules
1. Only teachers can create quizzes (checked in the action **and** in the RLS policy via `is_teacher()`).
2. A teacher sees and edits only **their own** quizzes (RLS: `teacher_id = auth.uid()`).
3. You can't publish a quiz with 0 questions.
4. A published quiz is **locked**: you must unpublish before adding or deleting questions, so students never see a quiz change halfway through.

## Likely viva questions
**Q: What is a Server Action?**
An async function marked `"use server"` that runs only on the server. We pass it to a form, as in `<form action={createQuiz}>`. When the form is submitted, Next.js sends the form data to the server, runs the function, and we redirect. There's no need to write a separate REST API.

**Q: Why check the role in both the Server Action and RLS?**
This is called **defence in depth**. The action check gives a friendly redirect. RLS is the real lock inside the database, so even someone calling the Supabase API directly with the public key can't create quizzes for another teacher.

**Q: Explain the questions RLS policy.**
`exists (select 1 from quizzes where quizzes.id = questions.quiz_id and quizzes.teacher_id = auth.uid())`. A teacher can touch a question only if the quiz it belongs to is theirs.

**Q: What is `is_teacher()` and why `security definer`?**
It's a SQL function that returns true if the logged-in user's profile role is 'teacher'. `security definer` makes it run with the owner's rights, so it can read `profiles` reliably from inside another table's policy. `set search_path = ''` is a security best practice that prevents someone from hijacking table names.

**Q: Why store options as 4 columns instead of a separate options table?**
The requirement is exactly 4 options per question, so 4 columns are simpler, need no joins, and the database itself enforces "always 4 options" (`not null`). A separate table would be better if the number of options varied.

**Q: What does `[id]` in a folder name mean?**
It's a dynamic route. `/teacher/quizzes/abc-123` opens the same page with `params.id = "abc-123"`.

**Q: What does `questions(count)` do in the select?**
Supabase sees the foreign key and returns the number of related questions for each quiz in one query, instead of making one query per quiz.

**Q: What are `revalidatePath` and `redirect`?**
After saving, `revalidatePath` tells Next.js to throw away cached page data so the updated list shows. `redirect` sends the user to the next page.

**Q: How do students avoid seeing `correct_option`?**
Right now students can't read these tables at all. In Phase 3 we'll give students access through a safe query that leaves out the correct answer, and do the grading on the server.

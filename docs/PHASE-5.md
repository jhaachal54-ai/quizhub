# Phase 5: School / College, Standard, Course & Year

## What we built
- On **signup**, a student chooses **🏫 School** or **🎓 College**:
  - School → dropdown for **1st to 12th standard**
  - College → **Course** (only BCA for now) + **Year** (1st/2nd/3rd)
- A **My profile** page (`/student/profile`) to change the name or class, for example after being promoted.
- Students who signed up **before** this phase are automatically sent to the profile page to fill in these details.
- The navbar shows a green badge such as **Class 7** or **BCA 2nd year**.
- The student dashboard shows **"Practice by subject"** cards for their level. The quizzes behind them arrive in Phase 6.

## Subject rules (`lib/education.js`)
| Level | Subjects |
|---|---|
| Class 1–8 | General Knowledge, Current Affairs, Maths, **Science** |
| Class 9–12 | General Knowledge, Current Affairs, Maths, **Physics, Chemistry, Biology** |
| BCA (1st–3rd year) | General Knowledge, Current Affairs, Maths, **DBMS, Java** |

Each level gets a short code (`school-7`, `BCA-2`). Phase 6 stores practice questions against these codes.

## Database changes (`supabase/phase5_education.sql`)
- New columns on `profiles`: `education_type`, `standard`, `course`, `college_year` (all null for teachers).
- `CHECK` constraints: standard 1–12, year 1–3, course in ('BCA'), and a combined rule that a row is **either** school with a standard **or** college with a course and year, never a mix.
- **Column-level GRANT**: `grant update (full_name, education_type, standard, course, college_year)`. Users can edit only these columns, and only on their own row (RLS). `role` is **not** in the list, so a student can't make themselves a teacher.
- The signup trigger `handle_new_user` now also copies the education details, after validating them.

## Likely viva questions
**Q: How do you stop a student changing their role while editing their profile?**
With a column-level GRANT: `UPDATE` is allowed only on the name and education columns. Even if someone sends `role: 'teacher'` in a request, PostgreSQL rejects it with "permission denied for column role". RLS (`auth.uid() = id`) also limits them to their own row.

**Q: Why are the subject rules in JavaScript and not the database?**
They're simple display logic used by several pages, so one shared file keeps them consistent. Phase 6 stores practice questions in the database with a level code, so the database decides which questions exist.

**Q: What happens to students who registered before this feature?**
Their education columns are null. The dashboard checks this and redirects them to `/student/profile?setup=1` until they fill it in.

**Q: Why validate in both the form and the database?**
The form gives instant friendly errors. The trigger and CHECK constraints guarantee correct data even if someone bypasses the form. The trigger also ignores bad values rather than failing the whole signup.

**Q: How does one `EducationFields` component work on two different pages?**
It renders ordinary named `<input>`/`<select>` elements. The signup page reads them with `new FormData(form)`, and the profile page sends them to a Server Action. Both use the same `readEducation()` validator in `lib/education.js`.

**Q: How would you add another course, like BCom?**
Add it to `COURSES` in `lib/education.js`, update the `check (course in (...))` constraint, and decide its subjects in `subjectsFor()`.

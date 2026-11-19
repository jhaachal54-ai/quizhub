# Phase 7: Quizzes Targeted to a Class & Subject

## What we built
- On **New Quiz** and **Edit quiz details**, the teacher must choose **who the quiz is for**:
  - 🏫 School → **Class** (1st–12th standard)
  - 🎓 College → **Course** (BCA) + **Year** (1st/2nd/3rd or **All years**)
  - **Subject**: the list changes with the class. For example, Class 5 gets Science, while Class 10 gets Physics, Chemistry and Biology.
- Quiz cards and the editor show a label such as **"Class 10 · Physics"** or **"BCA 2nd year · DBMS"**.
- A quiz can't be **published** until its class and subject are set.
- Students see **only** teacher quizzes for their own class/course, with a subject tag on each card.
- Old quizzes created before this phase were **unpublished** automatically (their results are kept). The teacher sets a class and subject, then publishes again.

## Database (`supabase/phase7_quiz_audience.sql`)
- New columns on `quizzes`: `subject`, `target_education_type`, `target_standard`, `target_course`, `target_college_year` (null means all years).
- A `CHECK` constraint `quizzes_audience_valid` requires a complete, consistent audience. A subject must belong to the level (no DBMS for Class 6), and a quiz can't be published without an audience.
- New function `quiz_is_for_me(quiz)`: true if the quiz is published and matches the logged-in student's class or course and year.
- `published_quizzes()` now returns only quizzes where `quiz_is_for_me` is true, plus the subject.
- `start_attempt()` now refuses quizzes that aren't for the student.

## Matching rules
| Quiz target | Student sees it if... |
|---|---|
| School, Class 7 | student is School **and** standard = 7 |
| College, BCA, 2nd year | student is College, course = BCA, **and** year = 2 |
| College, BCA, All years | student is College **and** course = BCA (any year) |

## Likely viva questions
**Q: Hiding a quiz from the list is easy. What stops a Class 6 student opening a Class 10 quiz by pasting its URL?**
The check is in the database, not just the list. `start_attempt` calls `quiz_is_for_me()` and raises an error if the quiz isn't for that student's class. The list filter is for convenience; the database check is for security.

**Q: Why use a separate function `quiz_is_for_me` instead of writing the condition twice?**
DRY (Don't Repeat Yourself). The listing and the start check use the same rule, so they can never disagree. Changing the rule means editing one place.

**Q: Why does the subject dropdown change when the class changes?**
`AudienceFields` is a Client Component with React state. It calls the same `subjectsFor()` function the student dashboard uses, so teachers can only pick subjects that exist for that class. The server action validates again with `readAudience()`, and the database `CHECK` constraint is the final guard.

**Q: What happened to quizzes made before this feature?**
The SQL unpublishes any published quiz without a subject before adding the constraint. The constraint wouldn't be valid otherwise, and students wouldn't know who those quizzes were for. Their attempts and results are untouched.

**Q: What if a student changes class after taking a quiz?**
Their attempt and result stay in the database. The quiz simply won't be listed for their new class.

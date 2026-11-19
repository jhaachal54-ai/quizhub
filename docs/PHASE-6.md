# Phase 6: Self-Practice Library

## What we built
- Each subject card on the student dashboard opens a **practice round**: up to 10 random questions for the student's level.
- **One question at a time.** After answering, the student sees right/wrong straight away, with a **one-line explanation**.
- **Unlimited rounds.** "Try another round" picks a new random set.
- **History**: the last 5 rounds per subject, and the best score plus number of rounds shown on the dashboard card.
- **New BCA subjects**: OOPS, C++, Cloud Computing, E-Business, and Data Communication & Computer Networks (in addition to GK, Current Affairs, Maths, DBMS and Java).
- **Question bank: 272 questions**, each with an explanation.

| Level | Bands | Subjects | Questions |
|---|---|---|---|
| School | Class 1-2, 3-5, 6-8 | GK, Current Affairs, Maths, Science | 96 |
| School | Class 9-10, 11-12 | GK, Current Affairs, Maths, Physics, Chemistry, Biology | 96 |
| College | BCA (all years) | 10 subjects | 80 |

## Database (`supabase/phase6_practice.sql` + 3 seed files)
- `practice_questions`: each question stores a **range** of standards (`min_standard`–`max_standard`, e.g. 3–5) or a `course` (BCA). A Class 4 student gets every question where `min_standard <= 4 <= max_standard`.
- `practice_attempts`: one row per finished round (student, subject, score, total, time).
- The seed files start with `delete ...`, so they can be re-run safely after editing.

## Exam vs Practice: the key difference
| | Teacher exam (Phase 3) | Practice (Phase 6) |
|---|---|---|
| Attempts | One | Unlimited |
| Timer | Yes, enforced by the server | No |
| Correct answers sent to the browser? | **Never** | **Yes**, for instant feedback |
| Graded where? | In the database | In the browser |
| Why? | Marks matter, so cheating must be impossible | It's for learning; there's nothing to gain by cheating |

## Likely viva questions
**Q: Why store a standard *range* rather than one standard per question?**
Many questions suit several classes. A range avoids duplicating them. For example, "What is the capital of India?" fits Class 3, 4 and 5. One query with `lte`/`gte` finds every question for a class.

**Q: How are questions picked randomly?**
The server loads all matching questions, shuffles them with the **Fisher–Yates algorithm** (`shuffle()` in `lib/education.js`), and takes the first 10. Fisher–Yates makes every order equally likely.

**Q: Practice sends correct answers to the browser. Isn't that a security problem?**
Not here. Practice has no marks. Instant feedback requires the browser to know the answer, and the explanation is the whole point of learning. Teacher exams still never send answers (Phase 3). The design decision depends on what's at stake.

**Q: A student could fake their practice score. Does it matter?**
Practice scores only appear in the student's own history, so they'd only be fooling themselves. The server action still checks that the score is between 0 and the total and that the subject belongs to their level.

**Q: How does "Try another round" get new questions?**
`router.refresh()` asks the server to re-render the page, so a new shuffle happens. The runner component gets a new random `key`, so React resets its state (score, current question).

**Q: How do you add more questions?**
Add rows to the seed SQL files and re-run them. (Phase 10 adds CSV bulk upload.)

**Q: Why are Current Affairs questions risky?**
They go out of date. They're marked "as of 2025" and should be reviewed every year.

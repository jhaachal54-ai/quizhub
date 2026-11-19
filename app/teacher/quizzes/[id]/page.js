// Quiz editor: edit details, add/delete questions, publish/unpublish, delete quiz.
// [id] in the folder name = dynamic route, e.g. /teacher/quizzes/1234-abcd
import Link from "next/link";
import { notFound } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import {
  addQuestion,
  deleteQuestion,
  deleteQuiz,
  setPublished,
  updateQuizDetails,
} from "../actions";
import QuizDetailsFields from "@/components/QuizDetailsFields";
import SubmitButton from "@/components/SubmitButton";
import Alert from "@/components/Alert";
import { inputClass } from "@/components/AuthCard";
import { audienceLabel } from "@/lib/education";

const OPTIONS = ["A", "B", "C", "D"];

export default async function QuizEditorPage({ params, searchParams }) {
  await requireRole("teacher");
  const { id } = await params;
  const { error, saved, added } = await searchParams;

  const supabase = await createClient();

  // RLS: returns nothing if this quiz belongs to another teacher
  const { data: quiz } = await supabase
    .from("quizzes")
    .select("*")
    .eq("id", id)
    .maybeSingle();

  if (!quiz) notFound();

  const [{ data: questions }, { data: results }] = await Promise.all([
    supabase
      .from("questions")
      .select("*")
      .eq("quiz_id", id)
      .order("created_at", { ascending: true }),
    supabase.rpc("quiz_results", { p_quiz_id: id }),
  ]);

  const attemptCount = results?.length ?? 0;
  // Questions can't change while published, or once anyone has attempted
  const hasAttempts = attemptCount > 0;
  const locked = quiz.is_published || hasAttempts;

  return (
    <div className="space-y-8">
      {/* ---------- Header ---------- */}
      <div>
        <Link href="/teacher" className="text-sm text-indigo-700">
          ← Back to my quizzes
        </Link>
        <div className="mt-2 flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold">{quiz.title}</h1>
            <p className="font-medium text-indigo-700">
              {audienceLabel(quiz) ?? (
                <span className="text-amber-700">⚠ Class & subject not set</span>
              )}
            </p>
            <p className="text-slate-600">
              {questions.length} questions · {quiz.time_limit_minutes} min ·{" "}
              {quiz.is_published ? (
                <span className="font-semibold text-green-700">Published</span>
              ) : (
                <span className="font-semibold text-amber-700">Draft</span>
              )}
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3">
          <Link
            href={`/teacher/quizzes/${quiz.id}/results`}
            className="rounded-lg border border-indigo-600 px-4 py-2 font-medium text-indigo-700 hover:bg-indigo-50"
          >
            View results ({attemptCount})
          </Link>
          <form action={setPublished}>
            <input type="hidden" name="quiz_id" value={quiz.id} />
            <input type="hidden" name="publish" value={String(!quiz.is_published)} />
            {quiz.is_published ? (
              <SubmitButton
                pendingText="Unpublishing..."
                className="rounded-lg border border-amber-500 px-4 py-2 font-medium text-amber-700 hover:bg-amber-50"
              >
                Unpublish
              </SubmitButton>
            ) : (
              <SubmitButton
                pendingText="Publishing..."
                className="rounded-lg bg-green-600 px-4 py-2 font-medium text-white hover:bg-green-700"
              >
                Publish quiz
              </SubmitButton>
            )}
          </form>
          </div>
        </div>
      </div>

      <Alert>{error}</Alert>
      {saved && <Alert type="success">Quiz details saved.</Alert>}
      {hasAttempts ? (
        <Alert type="success">
          {attemptCount} student(s) have attempted this quiz, so its questions are
          locked to keep scores fair. You can still edit the title, description and
          publish status.
        </Alert>
      ) : (
        quiz.is_published && (
          <Alert type="success">
            This quiz is live for students. Unpublish it if you need to change
            questions.
          </Alert>
        )
      )}

      {!quiz.subject && (
        <Alert>
          Students can&apos;t see this quiz until you choose its class and subject.
          Open &quot;Edit quiz details&quot; below.
        </Alert>
      )}

      {/* ---------- Quiz details ---------- */}
      {/* Opens automatically when the class/subject still needs to be set */}
      <details open={!quiz.subject} className="rounded-xl bg-white p-6 shadow-sm">
        <summary className="cursor-pointer font-semibold">Edit quiz details</summary>
        <form action={updateQuizDetails} className="mt-4 space-y-4">
          <input type="hidden" name="quiz_id" value={quiz.id} />
          <QuizDetailsFields quiz={quiz} />
          <SubmitButton className="rounded-lg bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700">
            Save details
          </SubmitButton>
        </form>
      </details>

      {/* ---------- Question list ---------- */}
      <section>
        <h2 className="mb-3 text-lg font-semibold">Questions</h2>
        {questions.length === 0 && (
          <p className="text-slate-500">No questions yet. Add one below.</p>
        )}
        <ol className="space-y-4">
          {questions.map((q, index) => (
            <li key={q.id} className="rounded-xl bg-white p-5 shadow-sm">
              <div className="flex items-start justify-between gap-4">
                <p className="font-medium">
                  Q{index + 1}. {q.question_text}
                </p>
                {!locked && (
                  <form action={deleteQuestion}>
                    <input type="hidden" name="quiz_id" value={quiz.id} />
                    <input type="hidden" name="question_id" value={q.id} />
                    <SubmitButton
                      pendingText="..."
                      confirmMessage="Delete this question?"
                      className="text-sm text-red-600 hover:underline"
                    >
                      Delete
                    </SubmitButton>
                  </form>
                )}
              </div>
              <ul className="mt-3 grid gap-2 sm:grid-cols-2">
                {OPTIONS.map((letter) => {
                  const correct = q.correct_option === letter;
                  return (
                    <li
                      key={letter}
                      className={`rounded-lg border px-3 py-2 text-sm ${
                        correct
                          ? "border-green-500 bg-green-50 font-medium text-green-800"
                          : "border-slate-200"
                      }`}
                    >
                      <b>{letter}.</b> {q[`option_${letter.toLowerCase()}`]}
                      {correct && " ✓"}
                    </li>
                  );
                })}
              </ul>
            </li>
          ))}
        </ol>
      </section>

      {/* ---------- Add question form ---------- */}
      {!locked && (
        <section id="add-question" className="rounded-xl bg-white p-6 shadow-sm">
          <h2 className="text-lg font-semibold">Add a question</h2>
          {added && (
            <div className="mt-3">
              <Alert type="success">Question added. Add another one?</Alert>
            </div>
          )}
          {/* key changes after every add -> React gives us a fresh empty form */}
          <form key={questions.length} action={addQuestion} className="mt-4 space-y-4">
            <input type="hidden" name="quiz_id" value={quiz.id} />
            <div>
              <label className="mb-1 block text-sm font-medium">Question</label>
              <textarea name="question_text" rows={2} className={inputClass} required />
            </div>

            <div className="space-y-2">
              <p className="text-sm font-medium">
                Options <span className="text-slate-500">(select the correct one)</span>
              </p>
              {OPTIONS.map((letter) => (
                <div key={letter} className="flex items-center gap-3">
                  <input
                    type="radio"
                    name="correct_option"
                    value={letter}
                    required
                    className="h-4 w-4 accent-green-600"
                    aria-label={`Option ${letter} is correct`}
                  />
                  <span className="w-5 font-semibold">{letter}.</span>
                  <input
                    name={`option_${letter.toLowerCase()}`}
                    className={inputClass}
                    placeholder={`Option ${letter}`}
                    required
                  />
                </div>
              ))}
            </div>

            <SubmitButton
              pendingText="Adding..."
              className="rounded-lg bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700"
            >
              Add question
            </SubmitButton>
          </form>
        </section>
      )}

      {/* ---------- Danger zone ---------- */}
      <form action={deleteQuiz} className="border-t border-slate-200 pt-6">
        <input type="hidden" name="quiz_id" value={quiz.id} />
        <SubmitButton
          pendingText="Deleting..."
          confirmMessage={
            hasAttempts
              ? `Delete this quiz? Its questions AND the results of ${attemptCount} student(s) will be permanently deleted.`
              : "Delete this quiz and all its questions? This cannot be undone."
          }
          className="rounded-lg border border-red-300 px-4 py-2 text-sm text-red-600 hover:bg-red-50"
        >
          Delete quiz
        </SubmitButton>
      </form>
    </div>
  );
}

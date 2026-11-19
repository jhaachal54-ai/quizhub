import Link from "next/link";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import { startQuiz } from "./quizzes/actions";
import SubmitButton from "@/components/SubmitButton";
import Alert from "@/components/Alert";
import { redirect } from "next/navigation";
import { SUBJECTS, levelLabel, subjectsFor } from "@/lib/education";

export default async function StudentDashboard({ searchParams }) {
  const { profile } = await requireRole("student");
  const { error, profile: profileSaved } = await searchParams;

  // Older accounts (made before Phase 5) must fill in class/course first
  if (!profile.education_type) redirect("/student/profile?setup=1");

  const supabase = await createClient();
  const mySubjects = subjectsFor(profile);

  // Best practice score + number of rounds for each subject
  const { data: practice } = await supabase
    .from("practice_attempts")
    .select("subject, score, total");
  const bestBySubject = {};
  for (const p of practice ?? []) {
    const percent = Math.round((p.score / p.total) * 100);
    const cur = bestBySubject[p.subject] ?? { percent: 0, rounds: 0 };
    bestBySubject[p.subject] = {
      percent: Math.max(cur.percent, percent),
      rounds: cur.rounds + 1,
    };
  }

  // 1. All published quizzes (safe function, no answers inside)
  const { data: quizzes, error: loadError } = await supabase.rpc("published_quizzes");

  // 2. This student's own attempts (RLS returns only their rows)
  const { data: attempts } = await supabase
    .from("attempts")
    .select("quiz_id, submitted_at, score, total_questions");

  // Turn the attempts list into a lookup: quizId -> attempt
  const attemptByQuiz = Object.fromEntries(
    (attempts ?? []).map((a) => [a.quiz_id, a])
  );

  return (
    <>
      <h1 className="text-2xl font-bold">Welcome, {profile.full_name}</h1>
      <p className="text-slate-600">
        {levelLabel(profile)} ·{" "}
        <Link href="/student/profile" className="text-indigo-700 hover:underline">
          change
        </Link>
      </p>

      {profileSaved && (
        <div className="mt-4">
          <Alert type="success">Profile saved.</Alert>
        </div>
      )}

      {/* ---------- Practice subjects for this level ---------- */}
      <h2 className="mt-8 text-lg font-semibold">Practice by subject</h2>
      <p className="text-sm text-slate-500">
        Ready-made quizzes for {levelLabel(profile)}. No teacher needed.
      </p>
      <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
        {mySubjects.map((key) => {
          const best = bestBySubject[key];
          return (
            <Link
              key={key}
              href={`/student/practice/${key}`}
              className="rounded-xl border border-slate-200 bg-white p-4 text-center shadow-sm transition hover:-translate-y-0.5 hover:border-indigo-300 hover:shadow"
            >
              <div className="text-3xl">{SUBJECTS[key].icon}</div>
              <div className="mt-1 text-sm font-medium">{SUBJECTS[key].name}</div>
              <div className="mt-1 text-xs text-slate-500">
                {best ? `Best: ${best.percent}% · ${best.rounds} rounds` : "Not tried yet"}
              </div>
            </Link>
          );
        })}
      </div>

      {/* ---------- Teacher quizzes ---------- */}
      <h2 className="mt-10 text-lg font-semibold">Quizzes from teachers</h2>

      <div className="mt-4 space-y-2">
        <Alert>{error}</Alert>
        {loadError && <Alert>Could not load quizzes: {loadError.message}</Alert>}
      </div>

      {quizzes?.length === 0 && (
        <div className="mt-10 rounded-xl border-2 border-dashed border-slate-300 p-10 text-center text-slate-500">
          Your teachers haven&apos;t published any quizzes for {levelLabel(profile)} yet.
          Try the practice subjects above!
        </div>
      )}

      <div className="mt-6 grid gap-4 sm:grid-cols-2">
        {quizzes?.map((quiz) => {
          const attempt = attemptByQuiz[quiz.id];
          return (
            <div
              key={quiz.id}
              className="flex flex-col rounded-xl border border-slate-200 bg-white p-5 shadow-sm"
            >
              {SUBJECTS[quiz.subject] && (
                <span className="mb-1 self-start rounded-full bg-indigo-50 px-2 py-0.5 text-xs font-medium text-indigo-700">
                  {SUBJECTS[quiz.subject].icon} {SUBJECTS[quiz.subject].name}
                </span>
              )}
              <h2 className="font-semibold">{quiz.title}</h2>
              {quiz.description && (
                <p className="mt-1 text-sm text-slate-600">{quiz.description}</p>
              )}
              <p className="mt-2 text-sm text-slate-500">
                {quiz.question_count} questions · {quiz.time_limit_minutes} min · by{" "}
                {quiz.teacher_name}
              </p>

              <div className="mt-4 flex items-center justify-between gap-2 pt-1">
                {!attempt && (
                  <form action={startQuiz}>
                    <input type="hidden" name="quiz_id" value={quiz.id} />
                    <SubmitButton
                      pendingText="Starting..."
                      confirmMessage={`You will have ${quiz.time_limit_minutes} minutes and only ONE attempt. The timer starts now. Ready?`}
                      className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700"
                    >
                      Start quiz
                    </SubmitButton>
                  </form>
                )}

                {attempt && !attempt.submitted_at && (
                  <Link
                    href={`/student/quizzes/${quiz.id}/attempt`}
                    className="rounded-lg bg-amber-500 px-4 py-2 text-sm font-medium text-white hover:bg-amber-600"
                  >
                    Continue (in progress)
                  </Link>
                )}

                {attempt?.submitted_at && (
                  <>
                    <span className="rounded-full bg-green-100 px-3 py-1 text-sm font-semibold text-green-700">
                      Score: {attempt.score}/{attempt.total_questions}
                    </span>
                    <Link
                      href={`/student/quizzes/${quiz.id}/result`}
                      className="text-sm font-medium text-indigo-700 hover:underline"
                    >
                      View result →
                    </Link>
                  </>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}

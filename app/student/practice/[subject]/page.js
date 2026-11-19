// Practice page for one subject: picks random questions for the student's level.
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import {
  SUBJECTS,
  filterPracticeForLevel,
  levelLabel,
  shuffle,
  subjectsFor,
} from "@/lib/education";
import PracticeRunner from "./PracticeRunner";

const QUESTIONS_PER_ROUND = 10;

export default async function PracticePage({ params }) {
  const { profile } = await requireRole("student");
  if (!profile.education_type) redirect("/student/profile?setup=1");

  const { subject } = await params;
  // Only subjects that belong to this student's level are allowed
  if (!subjectsFor(profile).includes(subject)) notFound();

  const supabase = await createClient();

  const [{ data: pool, error }, { data: history }] = await Promise.all([
    filterPracticeForLevel(
      supabase
        .from("practice_questions")
        .select("id, question_text, option_a, option_b, option_c, option_d, correct_option, explanation")
        .eq("subject", subject),
      profile
    ),
    supabase
      .from("practice_attempts")
      .select("score, total, created_at")
      .eq("subject", subject)
      .order("created_at", { ascending: false })
      .limit(5),
  ]);

  // Random order every time -> each round feels different
  const questions = shuffle(pool ?? []).slice(0, QUESTIONS_PER_ROUND);
  const info = SUBJECTS[subject];

  return (
    <div className="mx-auto max-w-2xl space-y-6">
      <Link href="/student" className="text-sm text-indigo-700">
        ← Back to dashboard
      </Link>
      <div className="flex items-center gap-3">
        <span className="text-4xl">{info.icon}</span>
        <div>
          <h1 className="text-2xl font-bold">{info.name} practice</h1>
          <p className="text-slate-600">
            {levelLabel(profile)} · {questions.length} random questions · no time limit
          </p>
        </div>
      </div>

      {error && (
        <p className="text-red-600">Could not load questions: {error.message}</p>
      )}

      {!error && questions.length === 0 ? (
        <p className="rounded-xl border-2 border-dashed border-slate-300 p-10 text-center text-slate-500">
          No practice questions for this subject at your level yet.
        </p>
      ) : (
        // key changes on every page load -> a fresh round after "Try again"
        <PracticeRunner
          key={crypto.randomUUID()}
          subject={subject}
          questions={questions}
        />
      )}

      {history?.length > 0 && (
        <section className="rounded-xl bg-white p-5 shadow-sm">
          <h2 className="font-semibold">Your recent rounds</h2>
          <ul className="mt-2 divide-y divide-slate-100 text-sm">
            {history.map((h, i) => (
              <li key={i} className="flex justify-between py-2">
                <span className="text-slate-500">
                  {new Date(h.created_at).toLocaleString("en-IN", {
                    dateStyle: "medium",
                    timeStyle: "short",
                    timeZone: "Asia/Kolkata",
                  })}
                </span>
                <span className="font-semibold">
                  {h.score}/{h.total} ({Math.round((h.score / h.total) * 100)}%)
                </span>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}

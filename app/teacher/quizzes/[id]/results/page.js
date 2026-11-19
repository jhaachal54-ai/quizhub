// Teacher results page: summary numbers, student list, per-question analysis.
import Link from "next/link";
import { notFound } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import ExportCsvButton from "@/components/ExportCsvButton";

const LETTERS = ["A", "B", "C", "D"];

function formatDate(value) {
  if (!value) return "—";
  return new Date(value).toLocaleString("en-IN", {
    dateStyle: "medium",
    timeStyle: "short",
    timeZone: "Asia/Kolkata",
  });
}

function pct(score, total) {
  return total > 0 ? Math.round((score / total) * 100) : 0;
}

export default async function QuizResultsPage({ params }) {
  await requireRole("teacher");
  const { id } = await params;
  const supabase = await createClient();

  // RLS: only the owner teacher gets the quiz row back
  const { data: quiz } = await supabase
    .from("quizzes")
    .select("id, title, time_limit_minutes, is_published")
    .eq("id", id)
    .maybeSingle();
  if (!quiz) notFound();

  // Run both queries at the same time
  const [{ data: results }, { data: stats }] = await Promise.all([
    supabase.rpc("quiz_results", { p_quiz_id: id }),
    supabase.rpc("question_stats", { p_quiz_id: id }),
  ]);

  const rows = results ?? [];
  const submitted = rows.filter((r) => r.submitted_at);
  const inProgress = rows.length - submitted.length;
  const percents = submitted.map((r) => pct(r.score, r.total_questions));
  const average = percents.length
    ? Math.round(percents.reduce((a, b) => a + b, 0) / percents.length)
    : null;
  const highest = percents.length ? Math.max(...percents) : null;
  const lowest = percents.length ? Math.min(...percents) : null;

  const csvRows = submitted.map((r, i) => [
    i + 1,
    r.student_name,
    r.student_email,
    r.score,
    r.total_questions,
    pct(r.score, r.total_questions),
    formatDate(r.submitted_at),
  ]);

  return (
    <div className="space-y-8">
      <div>
        <Link href={`/teacher/quizzes/${id}`} className="text-sm text-indigo-700">
          ← Back to quiz
        </Link>
        <div className="mt-2 flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold">Results: {quiz.title}</h1>
            <p className="text-slate-600">
              {submitted.length} submitted
              {inProgress > 0 && ` · ${inProgress} still in progress`}
            </p>
          </div>
          <ExportCsvButton
            filename={`${quiz.title.replace(/[^\w-]+/g, "_")}_results.csv`}
            headers={["Rank", "Name", "Email", "Score", "Total", "Percent", "Submitted at"]}
            rows={csvRows}
          />
        </div>
      </div>

      {/* ---------- Summary cards ---------- */}
      <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <Stat label="Students submitted" value={submitted.length} />
        <Stat label="Class average" value={average === null ? "—" : `${average}%`} />
        <Stat label="Highest" value={highest === null ? "—" : `${highest}%`} />
        <Stat label="Lowest" value={lowest === null ? "—" : `${lowest}%`} />
      </div>

      {/* ---------- Student table ---------- */}
      <section>
        <h2 className="mb-3 text-lg font-semibold">Students</h2>
        {rows.length === 0 ? (
          <p className="rounded-xl border-2 border-dashed border-slate-300 p-8 text-center text-slate-500">
            No student has attempted this quiz yet.
          </p>
        ) : (
          <div className="overflow-x-auto rounded-xl bg-white shadow-sm">
            <table className="w-full text-left text-sm">
              <thead className="border-b border-slate-200 bg-slate-50 text-slate-600">
                <tr>
                  <th className="px-4 py-3">#</th>
                  <th className="px-4 py-3">Student</th>
                  <th className="px-4 py-3">Score</th>
                  <th className="px-4 py-3">Submitted</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {rows.map((r, i) => (
                  <tr key={r.attempt_id} className="border-b border-slate-100 last:border-0">
                    <td className="px-4 py-3 text-slate-500">{i + 1}</td>
                    <td className="px-4 py-3">
                      <div className="font-medium">{r.student_name}</div>
                      <div className="text-xs text-slate-500">{r.student_email}</div>
                    </td>
                    <td className="px-4 py-3">
                      {r.submitted_at ? (
                        <span className="font-semibold">
                          {r.score}/{r.total_questions}{" "}
                          <span className="font-normal text-slate-500">
                            ({pct(r.score, r.total_questions)}%)
                          </span>
                        </span>
                      ) : (
                        <span className="rounded-full bg-amber-100 px-2 py-0.5 text-xs font-semibold text-amber-700">
                          In progress
                        </span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-slate-600">{formatDate(r.submitted_at)}</td>
                    <td className="px-4 py-3 text-right">
                      {r.submitted_at && (
                        <Link
                          href={`/teacher/quizzes/${id}/results/${r.attempt_id}`}
                          className="font-medium text-indigo-700 hover:underline"
                        >
                          View answers →
                        </Link>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {/* ---------- Question analysis ---------- */}
      {submitted.length > 0 && (
        <section>
          <h2 className="mb-1 text-lg font-semibold">Question analysis</h2>
          <p className="mb-3 text-sm text-slate-500">
            How many students got each question right, and which options they picked.
          </p>
          <ol className="space-y-4">
            {(stats ?? []).map((s, i) => {
              const correctPct = pct(s.correct, s.responses);
              const barColor =
                correctPct >= 75 ? "bg-green-500" : correctPct >= 40 ? "bg-amber-500" : "bg-red-500";
              return (
                <li key={s.question_id} className="rounded-xl bg-white p-5 shadow-sm">
                  <div className="flex items-start justify-between gap-4">
                    <p className="font-medium">
                      Q{i + 1}. {s.question_text}
                    </p>
                    <span className="whitespace-nowrap text-sm font-semibold">
                      {s.correct}/{s.responses} correct
                    </span>
                  </div>
                  <div className="mt-3 h-2.5 w-full overflow-hidden rounded-full bg-slate-100">
                    <div className={`h-full ${barColor}`} style={{ width: `${correctPct}%` }} />
                  </div>
                  <div className="mt-3 flex flex-wrap gap-2 text-xs">
                    {LETTERS.map((letter) => (
                      <span
                        key={letter}
                        className={`rounded-full px-2.5 py-1 ${
                          s.correct_option === letter
                            ? "bg-green-100 font-semibold text-green-800"
                            : "bg-slate-100 text-slate-600"
                        }`}
                      >
                        {letter}: {s[`picked_${letter.toLowerCase()}`]}
                        {s.correct_option === letter && " ✓"}
                      </span>
                    ))}
                    <span className="rounded-full bg-slate-100 px-2.5 py-1 text-slate-600">
                      Skipped: {s.skipped}
                    </span>
                  </div>
                </li>
              );
            })}
          </ol>
        </section>
      )}
    </div>
  );
}

function Stat({ label, value }) {
  return (
    <div className="rounded-xl bg-white p-4 shadow-sm">
      <p className="text-xs uppercase tracking-wide text-slate-500">{label}</p>
      <p className="mt-1 text-2xl font-bold text-indigo-700">{value}</p>
    </div>
  );
}

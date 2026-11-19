import Link from "next/link";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import { audienceLabel } from "@/lib/education";

export default async function TeacherDashboard() {
  const { profile } = await requireRole("teacher");
  const supabase = await createClient();

  // RLS makes sure this returns ONLY this teacher's quizzes.
  // "questions(count)" asks Supabase to count related questions too.
  const { data: quizzes, error } = await supabase
    .from("quizzes")
    .select(
      "id, title, time_limit_minutes, is_published, created_at, subject, " +
        "target_education_type, target_standard, target_course, target_college_year, questions(count)"
    )
    .order("created_at", { ascending: false });

  return (
    <>
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">My Quizzes</h1>
          <p className="text-slate-600">Welcome, {profile.full_name}</p>
        </div>
        <Link
          href="/teacher/quizzes/new"
          className="rounded-lg bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700"
        >
          + New Quiz
        </Link>
      </div>

      {error && (
        <p className="mt-6 text-red-600">Could not load quizzes: {error.message}</p>
      )}

      {quizzes?.length === 0 && (
        <div className="mt-10 rounded-xl border-2 border-dashed border-slate-300 p-10 text-center text-slate-500">
          You haven&apos;t created any quizzes yet. Click <b>+ New Quiz</b> to start.
        </div>
      )}

      <div className="mt-6 grid gap-4 sm:grid-cols-2">
        {quizzes?.map((quiz) => (
          <Link
            key={quiz.id}
            href={`/teacher/quizzes/${quiz.id}`}
            className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm transition hover:border-indigo-300 hover:shadow"
          >
            <div className="flex items-start justify-between gap-2">
              <h2 className="font-semibold">{quiz.title}</h2>
              <StatusBadge published={quiz.is_published} />
            </div>
            <p className="mt-1 text-sm font-medium text-indigo-700">
              {audienceLabel(quiz) ?? (
                <span className="text-amber-700">⚠ Class & subject not set</span>
              )}
            </p>
            <p className="mt-1 text-sm text-slate-600">
              {quiz.questions[0]?.count ?? 0} questions · {quiz.time_limit_minutes} min
            </p>
          </Link>
        ))}
      </div>
    </>
  );
}

function StatusBadge({ published }) {
  return published ? (
    <span className="rounded-full bg-green-100 px-2 py-0.5 text-xs font-semibold text-green-700">
      Published
    </span>
  ) : (
    <span className="rounded-full bg-amber-100 px-2 py-0.5 text-xs font-semibold text-amber-700">
      Draft
    </span>
  );
}

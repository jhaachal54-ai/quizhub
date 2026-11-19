import Link from "next/link";

export default function QuizNotFound() {
  return (
    <div className="py-20 text-center">
      <h1 className="text-xl font-bold">Quiz not found</h1>
      <p className="mt-2 text-slate-600">
        It doesn&apos;t exist, or it belongs to another teacher.
      </p>
      <Link href="/teacher" className="mt-4 inline-block text-indigo-700">
        ← Back to my quizzes
      </Link>
    </div>
  );
}

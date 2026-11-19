import Link from "next/link";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center px-4 text-center">
      <h1 className="text-4xl font-bold text-indigo-700">QuizHub</h1>
      <p className="mt-3 max-w-md text-slate-600">
        An online exam platform. Teachers create timed quizzes, students attempt
        them and get their score instantly.
      </p>
      <div className="mt-8 flex gap-4">
        <Link
          href="/login"
          className="rounded-lg bg-indigo-600 px-6 py-2.5 font-medium text-white hover:bg-indigo-700"
        >
          Log in
        </Link>
        <Link
          href="/signup"
          className="rounded-lg border border-indigo-600 px-6 py-2.5 font-medium text-indigo-700 hover:bg-indigo-50"
        >
          Sign up
        </Link>
      </div>
    </main>
  );
}

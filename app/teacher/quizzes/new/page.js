import Link from "next/link";
import { createQuiz } from "../actions";
import QuizDetailsFields from "@/components/QuizDetailsFields";
import SubmitButton from "@/components/SubmitButton";
import Alert from "@/components/Alert";

export default async function NewQuizPage({ searchParams }) {
  const { error } = await searchParams;

  return (
    <div className="mx-auto max-w-xl">
      <Link href="/teacher" className="text-sm text-indigo-700">
        ← Back to my quizzes
      </Link>
      <h1 className="mt-2 text-2xl font-bold">Create a new quiz</h1>
      <p className="text-slate-600">
        Fill in the details. You&apos;ll add questions on the next screen.
      </p>

      {/* action={createQuiz} sends the form straight to the Server Action */}
      <form action={createQuiz} className="mt-6 space-y-4 rounded-xl bg-white p-6 shadow-sm">
        <Alert>{error}</Alert>
        <QuizDetailsFields />
        <SubmitButton
          pendingText="Creating..."
          className="rounded-lg bg-indigo-600 px-5 py-2.5 font-medium text-white hover:bg-indigo-700"
        >
          Create quiz &amp; add questions →
        </SubmitButton>
      </form>
    </div>
  );
}

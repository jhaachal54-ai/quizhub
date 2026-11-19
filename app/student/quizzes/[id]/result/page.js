// Result page: score + a review of every question (shown only after submit).
import Link from "next/link";
import { redirect } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import AnswerReview, { ScoreCard } from "@/components/AnswerReview";

export default async function ResultPage({ params }) {
  await requireRole("student");
  const { id: quizId } = await params;
  const supabase = await createClient();

  const { data: result } = await supabase.rpc("get_my_result", { p_quiz_id: quizId });

  // Not submitted yet (or no attempt) -> back to dashboard
  if (!result) redirect("/student");

  return (
    <div className="space-y-8">
      <Link href="/student" className="text-sm text-indigo-700">
        ← Back to quizzes
      </Link>
      <ScoreCard
        title={result.quiz_title}
        score={result.score}
        total={result.total}
        startedAt={result.started_at}
        submittedAt={result.submitted_at}
        questions={result.questions}
      />
      <AnswerReview questions={result.questions} whose="your" />
    </div>
  );
}

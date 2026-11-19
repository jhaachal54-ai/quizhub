// Teacher view of ONE student's answer sheet.
import Link from "next/link";
import { notFound } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import AnswerReview, { ScoreCard } from "@/components/AnswerReview";

export default async function StudentAttemptPage({ params }) {
  await requireRole("teacher");
  const { id, attemptId } = await params;
  const supabase = await createClient();

  // Returns null unless this attempt belongs to one of THIS teacher's quizzes
  const { data: detail } = await supabase.rpc("attempt_detail", {
    p_attempt_id: attemptId,
  });
  if (!detail || !detail.submitted_at) notFound();

  return (
    <div className="space-y-8">
      <Link href={`/teacher/quizzes/${id}/results`} className="text-sm text-indigo-700">
        ← Back to results
      </Link>
      <ScoreCard
        title={`${detail.student_name} · ${detail.quiz_title}`}
        subtitle={detail.student_email}
        score={detail.score}
        total={detail.total}
        startedAt={detail.started_at}
        submittedAt={detail.submitted_at}
        questions={detail.questions}
      />
      <AnswerReview questions={detail.questions} whose="student's" />
    </div>
  );
}

// Exam page (Server Component part). Loads the attempt from the database,
// then hands the questions to <QuizRunner>, which runs in the browser.
import { redirect } from "next/navigation";
import { requireRole } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import QuizRunner from "./QuizRunner";

export default async function AttemptPage({ params }) {
  await requireRole("student");
  const { id: quizId } = await params;
  const supabase = await createClient();

  const { data: session, error } = await supabase.rpc("get_attempt_session", {
    p_quiz_id: quizId,
  });

  // Not started (or bad link) -> back to the list
  if (error || !session) redirect("/student");

  // Already submitted -> straight to the result
  if (session.submitted) redirect(`/student/quizzes/${quizId}/result`);

  // Time ran out while the student was away -> close the attempt now
  const graceMs = 30 * 1000;
  if (new Date(session.server_now) > new Date(new Date(session.deadline).getTime() + graceMs)) {
    await supabase.rpc("submit_attempt", {
      p_attempt_id: session.attempt_id,
      p_answers: {},
    });
    redirect(`/student/quizzes/${quizId}/result`);
  }

  return <QuizRunner session={session} />;
}

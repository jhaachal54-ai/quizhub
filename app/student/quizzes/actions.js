"use server";
// Student Server Actions. The actual rules (one attempt, time limit,
// grading) live in the database functions from phase3_attempts.sql.

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth";

// Called by the "Start quiz" button on the student dashboard
export async function startQuiz(formData) {
  await requireRole("student");
  const quizId = String(formData.get("quiz_id"));

  const supabase = await createClient();
  const { error } = await supabase.rpc("start_attempt", { p_quiz_id: quizId });

  if (error) redirect(`/student?error=${encodeURIComponent(error.message)}`);
  redirect(`/student/quizzes/${quizId}/attempt`);
}

// Called by the exam page (a Client Component) when the student submits,
// or automatically when the timer reaches 0.
export async function submitQuiz(attemptId, quizId, answers) {
  await requireRole("student");

  const supabase = await createClient();
  const { error } = await supabase.rpc("submit_attempt", {
    p_attempt_id: attemptId,
    p_answers: answers,
  });

  // Returning an object lets the client show the error and retry
  if (error) return { error: error.message };

  revalidatePath("/student");
  redirect(`/student/quizzes/${quizId}/result`);
}

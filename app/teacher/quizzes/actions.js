"use server";
// Server Actions = functions that run ONLY on the server.
// Forms call them directly, so no separate API route is needed.
// Every action checks the role again: never trust the browser.

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth";
import { readAudience } from "@/lib/education";

// Small helper: go back to a page with an error message in the URL
function fail(path, message) {
  redirect(`${path}?error=${encodeURIComponent(message)}`);
}

// ---------- QUIZZES ----------

export async function createQuiz(formData) {
  const { user } = await requireRole("teacher");

  const title = String(formData.get("title") || "").trim();
  const description = String(formData.get("description") || "").trim();
  const timeLimit = Number(formData.get("time_limit_minutes"));

  if (!title) fail("/teacher/quizzes/new", "Title is required");
  if (!Number.isInteger(timeLimit) || timeLimit < 1 || timeLimit > 300)
    fail("/teacher/quizzes/new", "Time limit must be 1 to 300 minutes");

  // Which class/course + subject the quiz is for (Phase 7)
  const audience = readAudience(formData);
  if (audience.error) fail("/teacher/quizzes/new", audience.error);

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("quizzes")
    .insert({
      teacher_id: user.id,
      title,
      description,
      time_limit_minutes: timeLimit,
      ...audience,
    })
    .select("id")
    .single();

  if (error) fail("/teacher/quizzes/new", error.message);

  redirect(`/teacher/quizzes/${data.id}`);
}

export async function updateQuizDetails(formData) {
  await requireRole("teacher");
  const quizId = String(formData.get("quiz_id"));
  const path = `/teacher/quizzes/${quizId}`;

  const title = String(formData.get("title") || "").trim();
  const description = String(formData.get("description") || "").trim();
  const timeLimit = Number(formData.get("time_limit_minutes"));

  if (!title) fail(path, "Title is required");
  if (!Number.isInteger(timeLimit) || timeLimit < 1 || timeLimit > 300)
    fail(path, "Time limit must be 1 to 300 minutes");

  const audience = readAudience(formData);
  if (audience.error) fail(path, audience.error);

  const supabase = await createClient();
  const { error } = await supabase
    .from("quizzes")
    .update({ title, description, time_limit_minutes: timeLimit, ...audience })
    .eq("id", quizId);

  if (error) fail(path, error.message);
  revalidatePath(path);
  redirect(`${path}?saved=1`);
}

export async function setPublished(formData) {
  await requireRole("teacher");
  const quizId = String(formData.get("quiz_id"));
  const publish = formData.get("publish") === "true";
  const path = `/teacher/quizzes/${quizId}`;

  const supabase = await createClient();

  if (publish) {
    // Rule: students must know who the quiz is for (Phase 7)
    const { data: quiz } = await supabase
      .from("quizzes")
      .select("subject")
      .eq("id", quizId)
      .single();
    if (!quiz?.subject)
      fail(path, "Open 'Edit quiz details' and choose the class and subject before publishing");

    // Rule: a quiz needs at least one question before students can see it
    const { count } = await supabase
      .from("questions")
      .select("id", { count: "exact", head: true })
      .eq("quiz_id", quizId);
    if (!count) fail(path, "Add at least one question before publishing");
  }

  const { error } = await supabase
    .from("quizzes")
    .update({ is_published: publish })
    .eq("id", quizId);

  if (error) fail(path, error.message);
  revalidatePath(path);
  revalidatePath("/teacher");
  redirect(path);
}

export async function deleteQuiz(formData) {
  await requireRole("teacher");
  const quizId = String(formData.get("quiz_id"));

  const supabase = await createClient();
  // Its questions are deleted automatically (ON DELETE CASCADE)
  const { error } = await supabase.from("quizzes").delete().eq("id", quizId);

  if (error) fail(`/teacher/quizzes/${quizId}`, error.message);
  revalidatePath("/teacher");
  redirect("/teacher");
}

// ---------- QUESTIONS ----------

export async function addQuestion(formData) {
  await requireRole("teacher");
  const quizId = String(formData.get("quiz_id"));
  const path = `/teacher/quizzes/${quizId}`;

  const question = {
    quiz_id: quizId,
    question_text: String(formData.get("question_text") || "").trim(),
    option_a: String(formData.get("option_a") || "").trim(),
    option_b: String(formData.get("option_b") || "").trim(),
    option_c: String(formData.get("option_c") || "").trim(),
    option_d: String(formData.get("option_d") || "").trim(),
    correct_option: String(formData.get("correct_option") || ""),
  };

  if (!question.question_text) fail(path, "Question text is required");
  if (
    !question.option_a || !question.option_b ||
    !question.option_c || !question.option_d
  )
    fail(path, "All 4 options are required");
  if (!["A", "B", "C", "D"].includes(question.correct_option))
    fail(path, "Choose the correct option");

  const supabase = await createClient();

  // Don't change questions of a quiz students can already see
  const { data: quiz } = await supabase
    .from("quizzes")
    .select("is_published")
    .eq("id", quizId)
    .single();
  if (quiz?.is_published) fail(path, "Unpublish the quiz before editing questions");

  const { error } = await supabase.from("questions").insert(question);
  if (error) fail(path, error.message);

  revalidatePath(path);
  redirect(`${path}?added=1#add-question`);
}

export async function deleteQuestion(formData) {
  await requireRole("teacher");
  const quizId = String(formData.get("quiz_id"));
  const questionId = String(formData.get("question_id"));
  const path = `/teacher/quizzes/${quizId}`;

  const supabase = await createClient();

  const { data: quiz } = await supabase
    .from("quizzes")
    .select("is_published")
    .eq("id", quizId)
    .single();
  if (quiz?.is_published) fail(path, "Unpublish the quiz before editing questions");

  const { error } = await supabase
    .from("questions")
    .delete()
    .eq("id", questionId);

  if (error) fail(path, error.message);
  revalidatePath(path);
  redirect(path);
}

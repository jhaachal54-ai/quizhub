"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth";
import { subjectsFor } from "@/lib/education";

// Saves one finished practice round to the student's history.
export async function savePracticeAttempt(subject, score, total) {
  const { user, profile } = await requireRole("student");

  if (!subjectsFor(profile).includes(subject)) return { error: "Unknown subject" };
  if (!Number.isInteger(total) || total < 1 || total > 50) return { error: "Bad total" };
  if (!Number.isInteger(score) || score < 0 || score > total) return { error: "Bad score" };

  const supabase = await createClient();
  const { error } = await supabase
    .from("practice_attempts")
    .insert({ student_id: user.id, subject, score, total });

  if (error) return { error: error.message };

  revalidatePath("/student");
  return { ok: true };
}

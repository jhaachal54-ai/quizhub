"use server";

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth";
import { readEducation } from "@/lib/education";

export async function updateProfile(formData) {
  const { user } = await requireRole("student");

  const fullName = String(formData.get("full_name") || "").trim();
  if (!fullName) redirect("/student/profile?error=Name is required");

  const education = readEducation(formData);
  if (education.error)
    redirect(`/student/profile?error=${encodeURIComponent(education.error)}`);

  const supabase = await createClient();
  // RLS + column grants: a user can only update these columns of their own row
  const { error } = await supabase
    .from("profiles")
    .update({ full_name: fullName, ...education })
    .eq("id", user.id);

  if (error) redirect(`/student/profile?error=${encodeURIComponent(error.message)}`);

  revalidatePath("/student", "layout");
  redirect("/student?profile=saved");
}

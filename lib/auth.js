// Helpers used by protected pages to get the current user + their role.
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

// Returns { user, profile } or sends the visitor to /login.
export async function getCurrentUser() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  const { data: profile, error } = await supabase
    .from("profiles")
    .select("id, full_name, role, education_type, standard, course, college_year")
    .eq("id", user.id)
    .maybeSingle();

  if (error) {
    console.error(
      `Profile load error: [${error.code}] ${error.message} ${error.details ?? ""} ${error.hint ?? ""}`
    );
  }

  return { user, profile, profileError: error };
}

// Only lets users with the given role see the page.
// A student opening /teacher gets sent to their own dashboard.
export async function requireRole(role) {
  const { user, profile } = await getCurrentUser();
  if (!profile) redirect("/dashboard"); // dashboard shows a "profile not found" message
  if (profile.role !== role) redirect(`/${profile.role}`);
  return { user, profile };
}

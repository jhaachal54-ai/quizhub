// "Traffic police" page: after login, send each user to the right dashboard.
import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";

export default async function DashboardRedirect() {
  const { user, profile, profileError } = await getCurrentUser();

  if (profile?.role === "teacher") redirect("/teacher");
  if (profile?.role === "student") redirect("/student");

  // Logged in but no profile row (e.g. the SQL trigger was added after signup)
  return (
    <main className="mx-auto max-w-md px-4 py-20 text-center">
      <h1 className="text-xl font-bold text-red-600">
        {profileError ? "Could not load your profile" : "Profile not found"}
      </h1>
      <p className="mt-2 text-slate-600">
        {profileError
          ? 'The database returned an error. If it says a column "does not exist", a phase SQL file in the supabase/ folder has not been run yet. Run it, then refresh.'
          : "Your account exists but has no profile row. Run supabase/phase1_profiles.sql, then delete this user in Supabase and sign up again."}
      </p>
      <p className="mt-4 break-all rounded bg-slate-100 p-3 text-left text-xs text-slate-700">
        Logged-in user id: {user.id}
        <br />
        Error: {profileError ? profileError.message : "none (row not visible)"}
      </p>
      <form action="/auth/signout" method="post" className="mt-6">
        <button className="rounded-lg border border-slate-300 px-4 py-2">
          Log out
        </button>
      </form>
    </main>
  );
}

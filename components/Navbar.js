// Top bar shown on the teacher and student dashboards.
import { levelLabel } from "@/lib/education";

export default function Navbar({ profile }) {
  const level = profile.role === "student" ? levelLabel(profile) : null;

  return (
    <header className="border-b border-slate-200 bg-white">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-4 px-4 py-3">
        <a href="/dashboard" className="text-lg font-bold text-indigo-700">
          QuizHub
        </a>
        <div className="flex items-center gap-3 sm:gap-4">
          <span className="hidden text-sm text-slate-600 sm:inline">
            {profile.full_name}{" "}
            <span className="rounded-full bg-indigo-100 px-2 py-0.5 text-xs font-semibold capitalize text-indigo-700">
              {profile.role}
            </span>
            {level && (
              <span className="ml-1 rounded-full bg-emerald-100 px-2 py-0.5 text-xs font-semibold text-emerald-700">
                {level}
              </span>
            )}
          </span>
          {profile.role === "student" && (
            <a href="/student/profile" className="text-sm text-indigo-700 hover:underline">
              My profile
            </a>
          )}
          {/* A plain HTML form POSTs to our sign-out route */}
          <form action="/auth/signout" method="post">
            <button className="rounded-lg border border-slate-300 px-3 py-1.5 text-sm hover:bg-slate-100">
              Log out
            </button>
          </form>
        </div>
      </div>
    </header>
  );
}

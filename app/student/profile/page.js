import Link from "next/link";
import { requireRole } from "@/lib/auth";
import { updateProfile } from "./actions";
import EducationFields from "@/components/EducationFields";
import SubmitButton from "@/components/SubmitButton";
import Alert from "@/components/Alert";
import { inputClass } from "@/components/AuthCard";

export default async function ProfilePage({ searchParams }) {
  const { profile } = await requireRole("student");
  const { error, setup } = await searchParams;
  const firstTime = setup || !profile.education_type;

  return (
    <div className="mx-auto max-w-md">
      {!firstTime && (
        <Link href="/student" className="text-sm text-indigo-700">
          ← Back to dashboard
        </Link>
      )}
      <h1 className="mt-2 text-2xl font-bold">
        {firstTime ? "Tell us where you study" : "My profile"}
      </h1>
      <p className="text-slate-600">
        {firstTime
          ? "We use this to show practice quizzes for your class or course."
          : "Moved to a new class? Update it here."}
      </p>

      <form action={updateProfile} className="mt-6 space-y-4 rounded-xl bg-white p-6 shadow-sm">
        <Alert>{error}</Alert>
        <div>
          <label className="mb-1 block text-sm font-medium">Full name</label>
          <input
            name="full_name"
            defaultValue={profile.full_name}
            className={inputClass}
            required
          />
        </div>
        <EducationFields initial={profile} />
        <SubmitButton className="w-full rounded-lg bg-indigo-600 py-2.5 font-medium text-white hover:bg-indigo-700">
          Save
        </SubmitButton>
      </form>
    </div>
  );
}

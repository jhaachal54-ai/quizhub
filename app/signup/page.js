"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import AuthCard, { inputClass, buttonClass } from "@/components/AuthCard";
import EducationFields from "@/components/EducationFields";
import { readEducation } from "@/lib/education";

export default function SignupPage() {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("student");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSignup(e) {
    e.preventDefault();
    setError("");
    setMessage("");

    // Students must tell us their class / course
    let education = {};
    if (role === "student") {
      education = readEducation(new FormData(e.currentTarget));
      if (education.error) {
        setError(education.error);
        return;
      }
    }

    setLoading(true);
    const supabase = createClient();

    // full_name, role and education are saved as "user metadata".
    // A database trigger copies them into the profiles table.
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName, role, ...education } },
    });

    setLoading(false);

    if (error) {
      setError(error.message);
      return;
    }

    if (data.session) {
      // Email confirmation is OFF -> user is logged in right away
      router.push("/dashboard");
      router.refresh();
    } else {
      // Email confirmation is ON -> user must click the link in their email
      setMessage("Account created! Check your email to confirm, then log in.");
    }
  }

  return (
    <AuthCard title="Create an account">
      <form onSubmit={handleSignup} className="space-y-4">
        <div>
          <label className="mb-1 block text-sm font-medium">Full name</label>
          <input
            className={inputClass}
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            required
          />
        </div>
        <div>
          <label className="mb-1 block text-sm font-medium">Email</label>
          <input
            type="email"
            className={inputClass}
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label className="mb-1 block text-sm font-medium">Password</label>
          <input
            type="password"
            className={inputClass}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            minLength={6}
            required
          />
        </div>
        <div>
          <span className="mb-1 block text-sm font-medium">I am a</span>
          <div className="grid grid-cols-2 gap-2">
            {["student", "teacher"].map((r) => (
              <button
                type="button"
                key={r}
                onClick={() => setRole(r)}
                className={`rounded-lg border py-2 capitalize ${
                  role === r
                    ? "border-indigo-600 bg-indigo-50 font-semibold text-indigo-700"
                    : "border-slate-300 text-slate-600"
                }`}
              >
                {r}
              </button>
            ))}
          </div>
        </div>

        {role === "student" && <EducationFields />}

        {error && <p className="text-sm text-red-600">{error}</p>}
        {message && <p className="text-sm text-green-700">{message}</p>}

        <button type="submit" disabled={loading} className={buttonClass}>
          {loading ? "Creating account..." : "Sign up"}
        </button>
      </form>

      <p className="mt-6 text-center text-sm text-slate-600">
        Already have an account?{" "}
        <Link href="/login" className="font-medium text-indigo-700">
          Log in
        </Link>
      </p>
    </AuthCard>
  );
}

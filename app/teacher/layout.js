// Layout = shared wrapper for every page under /teacher (navbar on top).
import { requireRole } from "@/lib/auth";
import Navbar from "@/components/Navbar";

export default async function TeacherLayout({ children }) {
  const { profile } = await requireRole("teacher");

  return (
    <>
      <Navbar profile={profile} />
      <main className="mx-auto max-w-5xl px-4 py-8">{children}</main>
    </>
  );
}

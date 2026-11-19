// Shared wrapper for every page under /student (navbar + role check).
import { requireRole } from "@/lib/auth";
import Navbar from "@/components/Navbar";

export default async function StudentLayout({ children }) {
  const { profile } = await requireRole("student");

  return (
    <>
      <Navbar profile={profile} />
      <main className="mx-auto max-w-5xl px-4 py-8">{children}</main>
    </>
  );
}

// Shared box layout for the login and signup pages.
export default function AuthCard({ title, children }) {
  return (
    <main className="flex min-h-screen items-center justify-center px-4">
      <div className="w-full max-w-sm rounded-2xl bg-white p-8 shadow-md">
        <h1 className="mb-6 text-center text-2xl font-bold text-indigo-700">
          {title}
        </h1>
        {children}
      </div>
    </main>
  );
}

export const inputClass =
  "w-full rounded-lg border border-slate-300 px-3 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200";

export const buttonClass =
  "w-full rounded-lg bg-indigo-600 py-2.5 font-medium text-white hover:bg-indigo-700 disabled:opacity-60";

import "./globals.css";

export const metadata = {
  title: "QuizHub - Online Exam Platform",
  description: "Teachers create quizzes, students attempt them.",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="min-h-screen">{children}</body>
    </html>
  );
}

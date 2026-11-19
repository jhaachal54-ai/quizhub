// Score card + question-by-question review.
// Used by the student result page AND the teacher's "view student answers" page.

const LETTERS = ["A", "B", "C", "D"];

export function ScoreCard({ title, subtitle, score, total, startedAt, submittedAt, questions }) {
  const percent = total > 0 ? Math.round((score / total) * 100) : 0;
  const skipped = questions.filter((q) => !q.selected_option).length;
  const minutesTaken = Math.max(
    1,
    Math.round((new Date(submittedAt) - new Date(startedAt)) / 60000)
  );
  const color =
    percent >= 75 ? "text-green-600" : percent >= 40 ? "text-amber-600" : "text-red-600";

  return (
    <div className="rounded-2xl bg-white p-8 text-center shadow-sm">
      <p className="text-slate-500">{title}</p>
      {subtitle && <p className="text-sm text-slate-400">{subtitle}</p>}
      <p className={`mt-2 text-6xl font-bold ${color}`}>
        {score}/{total}
      </p>
      <p className={`mt-1 text-xl font-semibold ${color}`}>{percent}%</p>
      <div className="mt-4 flex flex-wrap justify-center gap-x-6 gap-y-1 text-sm text-slate-600">
        <span>✓ Correct: {score}</span>
        <span>✗ Wrong: {total - score - skipped}</span>
        <span>– Skipped: {skipped}</span>
        <span>⏱ Time taken: ~{minutesTaken} min</span>
      </div>
    </div>
  );
}

export default function AnswerReview({ questions, whose = "your" }) {
  return (
    <section>
      <h2 className="mb-3 text-lg font-semibold">Answer review</h2>
      <ol className="space-y-4">
        {questions.map((q, index) => (
          <li
            key={index}
            className={`rounded-xl border-l-4 bg-white p-5 shadow-sm ${
              q.is_correct ? "border-green-500" : "border-red-500"
            }`}
          >
            <p className="font-medium">
              Q{index + 1}. {q.question_text}
            </p>
            <ul className="mt-3 grid gap-2 sm:grid-cols-2">
              {LETTERS.map((letter) => {
                const isCorrect = q.correct_option === letter;
                const isPicked = q.selected_option === letter;
                let style = "border-slate-200";
                if (isCorrect) style = "border-green-500 bg-green-50 text-green-800";
                else if (isPicked) style = "border-red-400 bg-red-50 text-red-800";
                return (
                  <li key={letter} className={`rounded-lg border px-3 py-2 text-sm ${style}`}>
                    <b>{letter}.</b> {q.options[letter]}
                    {isCorrect && " ✓"}
                    {isPicked && !isCorrect && ` ✗ (${whose} answer)`}
                    {isPicked && isCorrect && ` (${whose} answer)`}
                  </li>
                );
              })}
            </ul>
            {!q.selected_option && (
              <p className="mt-2 text-sm text-slate-500">Skipped.</p>
            )}
          </li>
        ))}
      </ol>
    </section>
  );
}

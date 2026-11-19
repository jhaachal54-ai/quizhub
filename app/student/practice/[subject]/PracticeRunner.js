"use client";
// Practice mode: one question at a time, instant right/wrong + explanation.

import { useState } from "react";
import { useRouter } from "next/navigation";
import { savePracticeAttempt } from "../actions";

const LETTERS = ["A", "B", "C", "D"];

export default function PracticeRunner({ subject, questions }) {
  const router = useRouter();
  const [index, setIndex] = useState(0);        // which question we're on
  const [picked, setPicked] = useState(null);   // letter chosen for this question
  const [score, setScore] = useState(0);
  const [finished, setFinished] = useState(false);
  const [saveError, setSaveError] = useState("");

  const q = questions[index];
  const answered = picked !== null;
  const isLast = index === questions.length - 1;

  function choose(letter) {
    if (answered) return; // can't change after seeing the answer
    setPicked(letter);
    if (letter === q.correct_option) setScore((s) => s + 1);
  }

  async function next() {
    if (!isLast) {
      setIndex((i) => i + 1);
      setPicked(null);
      return;
    }
    setFinished(true);
    // "score" state is already final here because choose() ran earlier
    const result = await savePracticeAttempt(subject, score, questions.length);
    if (result?.error) setSaveError(`Score not saved: ${result.error}`);
  }

  if (finished) {
    const percent = Math.round((score / questions.length) * 100);
    const message =
      percent === 100 ? "Perfect score! 🎉" :
      percent >= 75   ? "Great job! 👏" :
      percent >= 40   ? "Good effort, keep practising! 💪" :
                        "Keep going, you'll get there! 📚";
    return (
      <div className="rounded-2xl bg-white p-8 text-center shadow-sm">
        <p className="text-slate-500">Round complete</p>
        <p className="mt-2 text-6xl font-bold text-indigo-700">
          {score}/{questions.length}
        </p>
        <p className="mt-2 text-lg">{message}</p>
        {saveError && <p className="mt-2 text-sm text-red-600">{saveError}</p>}
        <button
          onClick={() => router.refresh()}
          className="mt-6 rounded-lg bg-indigo-600 px-6 py-2.5 font-medium text-white hover:bg-indigo-700"
        >
          Try another round
        </button>
      </div>
    );
  }

  return (
    <div className="rounded-2xl bg-white p-6 shadow-sm">
      {/* Progress bar */}
      <div className="flex items-center justify-between text-sm text-slate-500">
        <span>
          Question {index + 1} of {questions.length}
        </span>
        <span>Score: {score}</span>
      </div>
      <div className="mt-2 h-2 overflow-hidden rounded-full bg-slate-100">
        <div
          className="h-full bg-indigo-500 transition-all"
          style={{ width: `${((index + (answered ? 1 : 0)) / questions.length) * 100}%` }}
        />
      </div>

      <p className="mt-6 text-lg font-medium">{q.question_text}</p>

      <div className="mt-4 grid gap-2">
        {LETTERS.map((letter) => {
          const text = q[`option_${letter.toLowerCase()}`];
          let style = "border-slate-200 hover:border-indigo-300 hover:bg-slate-50";
          if (answered) {
            if (letter === q.correct_option) style = "border-green-500 bg-green-50 text-green-800";
            else if (letter === picked) style = "border-red-400 bg-red-50 text-red-800";
            else style = "border-slate-200 opacity-60";
          }
          return (
            <button
              key={letter}
              onClick={() => choose(letter)}
              disabled={answered}
              className={`rounded-lg border px-4 py-3 text-left transition ${style}`}
            >
              <b>{letter}.</b> {text}
              {answered && letter === q.correct_option && " ✓"}
              {answered && letter === picked && letter !== q.correct_option && " ✗"}
            </button>
          );
        })}
      </div>

      {answered && (
        <div
          className={`mt-4 rounded-lg p-4 text-sm ${
            picked === q.correct_option ? "bg-green-50 text-green-800" : "bg-amber-50 text-amber-900"
          }`}
        >
          <p className="font-semibold">
            {picked === q.correct_option
              ? "Correct!"
              : `Not quite. The answer is ${q.correct_option}.`}
          </p>
          {q.explanation && <p className="mt-1">{q.explanation}</p>}
        </div>
      )}

      <div className="mt-6 flex justify-end">
        <button
          onClick={next}
          disabled={!answered}
          className="rounded-lg bg-indigo-600 px-6 py-2.5 font-medium text-white hover:bg-indigo-700 disabled:opacity-40"
        >
          {isLast ? "Finish" : "Next →"}
        </button>
      </div>
    </div>
  );
}

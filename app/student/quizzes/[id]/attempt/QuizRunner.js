"use client";
// The live exam screen: countdown timer, questions, answer selection, submit.
// Runs in the browser because it needs state, a ticking clock and clicks.

import { useCallback, useEffect, useRef, useState } from "react";
import { submitQuiz } from "../../actions";

const LETTERS = ["A", "B", "C", "D"];

function formatTime(totalSeconds) {
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

export default function QuizRunner({ session }) {
  const { attempt_id, quiz_id, quiz_title, deadline, server_now, questions } = session;
  const storageKey = `quiz-answers-${attempt_id}`;

  const [answers, setAnswers] = useState({}); // { questionId: "A" }
  const [secondsLeft, setSecondsLeft] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  // Refs hold the latest values without re-running effects
  const answersRef = useRef({});
  const submittedRef = useRef(false);

  // 1. Restore answers saved in this browser (survives a page refresh)
  useEffect(() => {
    try {
      const saved = JSON.parse(localStorage.getItem(storageKey) || "{}");
      answersRef.current = saved;
      setAnswers(saved);
    } catch {
      /* localStorage unavailable: just start empty */
    }
  }, [storageKey]);

  function choose(questionId, letter) {
    const next = { ...answersRef.current, [questionId]: letter };
    answersRef.current = next;
    setAnswers(next);
    try {
      localStorage.setItem(storageKey, JSON.stringify(next));
    } catch {}
  }

  // 2. Submit (manual click, or automatic when time is up)
  const submit = useCallback(
    async (auto = false) => {
      if (submittedRef.current) return;

      if (!auto) {
        const unanswered = questions.length - Object.keys(answersRef.current).length;
        const msg =
          unanswered > 0
            ? `You have ${unanswered} unanswered question(s). Submit anyway?`
            : "Submit your answers? You cannot change them after this.";
        if (!window.confirm(msg)) return;
      }

      submittedRef.current = true;
      setSubmitting(true);
      setError("");

      // On success the server action redirects to the result page
      const result = await submitQuiz(attempt_id, quiz_id, answersRef.current);

      if (result?.error) {
        submittedRef.current = false;
        setSubmitting(false);
        setError(result.error + " Please try again.");
      } else {
        try {
          localStorage.removeItem(storageKey);
        } catch {}
      }
    },
    [attempt_id, quiz_id, questions.length, storageKey]
  );

  // 3. Countdown timer. The deadline comes from the SERVER, and we correct
  //    for the student's computer clock being wrong (offset).
  useEffect(() => {
    const offset = new Date(server_now).getTime() - Date.now();
    const end = new Date(deadline).getTime();

    function tick() {
      const left = Math.max(0, Math.round((end - (Date.now() + offset)) / 1000));
      setSecondsLeft(left);
      if (left === 0) submit(true);
    }

    tick();
    const timer = setInterval(tick, 1000);
    return () => clearInterval(timer);
  }, [deadline, server_now, submit]);

  // 4. Warn before closing/refreshing the tab during the exam
  useEffect(() => {
    function warn(e) {
      if (!submittedRef.current) e.preventDefault();
    }
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, []);

  const answeredCount = Object.keys(answers).length;
  const lowTime = secondsLeft !== null && secondsLeft <= 60;

  return (
    <div className="pb-24">
      {/* Sticky top bar with timer */}
      <div className="sticky top-0 z-10 -mx-4 mb-6 border-b border-slate-200 bg-white/95 px-4 py-3 backdrop-blur">
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div>
            <h1 className="font-bold">{quiz_title}</h1>
            <p className="text-sm text-slate-600">
              Answered {answeredCount} of {questions.length}
            </p>
          </div>
          <div
            className={`rounded-lg px-4 py-2 font-mono text-xl font-bold ${
              lowTime ? "animate-pulse bg-red-100 text-red-700" : "bg-indigo-50 text-indigo-700"
            }`}
            aria-live="polite"
          >
            ⏱ {secondsLeft === null ? "--:--" : formatTime(secondsLeft)}
          </div>
        </div>
      </div>

      {error && (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
          {error}
        </div>
      )}

      {/* Questions */}
      <ol className="space-y-5">
        {questions.map((q, index) => (
          <li key={q.id} className="rounded-xl bg-white p-5 shadow-sm">
            <p className="font-medium">
              Q{index + 1}. {q.question_text}
            </p>
            <div className="mt-3 grid gap-2 sm:grid-cols-2">
              {LETTERS.map((letter) => {
                const selected = answers[q.id] === letter;
                return (
                  <button
                    key={letter}
                    type="button"
                    disabled={submitting}
                    onClick={() => choose(q.id, letter)}
                    className={`rounded-lg border px-3 py-2 text-left text-sm transition ${
                      selected
                        ? "border-indigo-600 bg-indigo-50 font-medium text-indigo-800 ring-2 ring-indigo-200"
                        : "border-slate-200 hover:border-indigo-300 hover:bg-slate-50"
                    }`}
                  >
                    <b>{letter}.</b> {q.options[letter]}
                  </button>
                );
              })}
            </div>
          </li>
        ))}
      </ol>

      {/* Submit bar */}
      <div className="fixed inset-x-0 bottom-0 border-t border-slate-200 bg-white px-4 py-3">
        <div className="mx-auto flex max-w-5xl items-center justify-between gap-4">
          <span className="text-sm text-slate-600">
            {answeredCount}/{questions.length} answered
          </span>
          <button
            onClick={() => submit(false)}
            disabled={submitting}
            className="rounded-lg bg-green-600 px-6 py-2.5 font-medium text-white hover:bg-green-700 disabled:opacity-60"
          >
            {submitting ? "Submitting..." : "Submit quiz"}
          </button>
        </div>
      </div>
    </div>
  );
}

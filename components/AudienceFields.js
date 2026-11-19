"use client";
// Teacher picks WHO the quiz is for (class or course + year) and the SUBJECT.
// The subject list changes with the class (e.g. Class 9+ gets Physics).

import { useState } from "react";
import { inputClass } from "@/components/AuthCard";
import {
  COLLEGE_YEARS,
  COURSES,
  STANDARDS,
  SUBJECTS,
  ordinal,
  subjectsFor,
} from "@/lib/education";

export default function AudienceFields({ quiz = {} }) {
  const [type, setType] = useState(quiz.target_education_type || "school");
  const [standard, setStandard] = useState(quiz.target_standard ?? "");
  const [course, setCourse] = useState(quiz.target_course || "BCA");
  const [subject, setSubject] = useState(quiz.subject || "");

  const subjects =
    type === "school"
      ? standard
        ? subjectsFor({ education_type: "school", standard: Number(standard) })
        : []
      : subjectsFor({ education_type: "college", course });

  // If the chosen subject isn't available any more, clear it
  const subjectValue = subjects.includes(subject) ? subject : "";

  return (
    <fieldset className="space-y-3 rounded-lg border border-slate-200 p-4">
      <legend className="px-1 text-sm font-semibold">Who is this quiz for?</legend>

      <input type="hidden" name="target_education_type" value={type} />
      <div className="grid grid-cols-2 gap-2">
        {["school", "college"].map((t) => (
          <button
            type="button"
            key={t}
            onClick={() => setType(t)}
            className={`rounded-lg border py-2 ${
              type === t
                ? "border-indigo-600 bg-indigo-50 font-semibold text-indigo-700"
                : "border-slate-300 text-slate-600"
            }`}
          >
            {t === "school" ? "🏫 School" : "🎓 College"}
          </button>
        ))}
      </div>

      {type === "school" ? (
        <div>
          <label className="mb-1 block text-sm font-medium">Class</label>
          <select
            name="target_standard"
            value={standard}
            onChange={(e) => setStandard(e.target.value)}
            className={inputClass}
            required
          >
            <option value="" disabled>
              Select class
            </option>
            {STANDARDS.map((s) => (
              <option key={s} value={s}>
                {ordinal(s)} standard
              </option>
            ))}
          </select>
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-2">
          <div>
            <label className="mb-1 block text-sm font-medium">Course</label>
            <select
              name="target_course"
              value={course}
              onChange={(e) => setCourse(e.target.value)}
              className={inputClass}
            >
              {COURSES.map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Year</label>
            <select
              name="target_college_year"
              defaultValue={quiz.target_college_year ?? "all"}
              className={inputClass}
            >
              <option value="all">All years</option>
              {COLLEGE_YEARS.map((y) => (
                <option key={y} value={y}>
                  {ordinal(y)} year
                </option>
              ))}
            </select>
          </div>
        </div>
      )}

      <div>
        <label className="mb-1 block text-sm font-medium">Subject</label>
        <select
          name="subject"
          value={subjectValue}
          onChange={(e) => setSubject(e.target.value)}
          className={inputClass}
          required
          disabled={subjects.length === 0}
        >
          <option value="" disabled>
            {subjects.length ? "Select subject" : "Select a class first"}
          </option>
          {subjects.map((key) => (
            <option key={key} value={key}>
              {SUBJECTS[key].icon} {SUBJECTS[key].name}
            </option>
          ))}
        </select>
      </div>
    </fieldset>
  );
}

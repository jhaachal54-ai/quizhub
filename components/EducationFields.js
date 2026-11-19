"use client";
// "School or College?" picker with the right dropdowns.
// Renders normal <input>/<select> elements with "name"s, so any form
// (signup page or profile page) can read the values with FormData.

import { useState } from "react";
import { inputClass } from "@/components/AuthCard";
import { STANDARDS, COURSES, COLLEGE_YEARS, ordinal } from "@/lib/education";

export default function EducationFields({ initial = {} }) {
  const [type, setType] = useState(initial.education_type || "school");

  return (
    <div className="space-y-3">
      <div>
        <span className="mb-1 block text-sm font-medium">I study in</span>
        <input type="hidden" name="education_type" value={type} />
        <div className="grid grid-cols-2 gap-2">
          {["school", "college"].map((t) => (
            <button
              type="button"
              key={t}
              onClick={() => setType(t)}
              className={`rounded-lg border py-2 capitalize ${
                type === t
                  ? "border-indigo-600 bg-indigo-50 font-semibold text-indigo-700"
                  : "border-slate-300 text-slate-600"
              }`}
            >
              {t === "school" ? "🏫 School" : "🎓 College"}
            </button>
          ))}
        </div>
      </div>

      {type === "school" ? (
        <div>
          <label className="mb-1 block text-sm font-medium">Standard / Class</label>
          <select
            name="standard"
            defaultValue={initial.standard ?? ""}
            className={inputClass}
            required
          >
            <option value="" disabled>
              Select your class
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
              name="course"
              defaultValue={initial.course ?? "BCA"}
              className={inputClass}
              required
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
              name="college_year"
              defaultValue={initial.college_year ?? ""}
              className={inputClass}
              required
            >
              <option value="" disabled>
                Select year
              </option>
              {COLLEGE_YEARS.map((y) => (
                <option key={y} value={y}>
                  {ordinal(y)} year
                </option>
              ))}
            </select>
          </div>
        </div>
      )}
    </div>
  );
}

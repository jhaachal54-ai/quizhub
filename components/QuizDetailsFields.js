// Title / description / time-limit inputs, shared by "new quiz" and "edit quiz".
import { inputClass } from "@/components/AuthCard";
import AudienceFields from "@/components/AudienceFields";

export default function QuizDetailsFields({ quiz = {} }) {
  return (
    <>
      <AudienceFields quiz={quiz} />
      <div>
        <label className="mb-1 block text-sm font-medium">Quiz title</label>
        <input
          name="title"
          defaultValue={quiz.title}
          className={inputClass}
          placeholder="e.g. DBMS Unit 1 Test"
          maxLength={200}
          required
        />
      </div>
      <div>
        <label className="mb-1 block text-sm font-medium">
          Description <span className="text-slate-400">(optional)</span>
        </label>
        <textarea
          name="description"
          defaultValue={quiz.description}
          className={inputClass}
          rows={3}
          placeholder="Instructions for students"
        />
      </div>
      <div>
        <label className="mb-1 block text-sm font-medium">Time limit (minutes)</label>
        <input
          name="time_limit_minutes"
          type="number"
          min={1}
          max={300}
          defaultValue={quiz.time_limit_minutes ?? 10}
          className={`${inputClass} max-w-[10rem]`}
          required
        />
      </div>
    </>
  );
}

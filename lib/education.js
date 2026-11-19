// Everything about "which class/course is this student in, and which
// subjects do they get". Kept in one place so every page agrees.

export const STANDARDS = Array.from({ length: 12 }, (_, i) => i + 1); // 1..12
export const COURSES = ["BCA"]; // add more college courses here later
export const COLLEGE_YEARS = [1, 2, 3];

export const SUBJECTS = {
  gk:              { name: "General Knowledge", icon: "🌍" },
  current_affairs: { name: "Current Affairs",   icon: "📰" },
  maths:           { name: "Maths",             icon: "➗" },
  science:         { name: "Science",           icon: "🔬" },
  physics:         { name: "Physics",           icon: "⚛️" },
  chemistry:       { name: "Chemistry",         icon: "🧪" },
  biology:         { name: "Biology",           icon: "🧬" },
  dbms:            { name: "DBMS",              icon: "🗄️" },
  java:            { name: "Java",              icon: "☕" },
  oops:            { name: "OOPS",              icon: "🧱" },
  cpp:             { name: "C++",               icon: "💻" },
  cloud:           { name: "Cloud Computing",   icon: "☁️" },
  ebusiness:       { name: "E-Business",        icon: "🛒" },
  dccn:            { name: "Data Comm. & Networks", icon: "🌐" },
};

export function ordinal(n) {
  return n === 1 ? "1st" : n === 2 ? "2nd" : n === 3 ? "3rd" : `${n}th`;
}

// A short code for the student's level, e.g. "school-7" or "BCA-2".
// Practice quizzes (Phase 6) are stored against this code.
export function levelKey(profile) {
  if (profile?.education_type === "school" && profile.standard)
    return `school-${profile.standard}`;
  if (profile?.education_type === "college" && profile.course && profile.college_year)
    return `${profile.course}-${profile.college_year}`;
  return null;
}

// Human-readable label, e.g. "Class 7" or "BCA 2nd year"
export function levelLabel(profile) {
  if (profile?.education_type === "school" && profile.standard)
    return `Class ${profile.standard}`;
  if (profile?.education_type === "college" && profile.course && profile.college_year)
    return `${profile.course} ${ordinal(profile.college_year)} year`;
  return null;
}

// Reads the <EducationFields> inputs from a form -> clean values or { error }
export function readEducation(formData) {
  const type = formData.get("education_type");
  if (type === "school") {
    const standard = Number(formData.get("standard"));
    if (!Number.isInteger(standard) || standard < 1 || standard > 12)
      return { error: "Please select your class (1 to 12)" };
    return { education_type: "school", standard, course: null, college_year: null };
  }
  if (type === "college") {
    const course = String(formData.get("course") || "");
    const year = Number(formData.get("college_year"));
    if (!COURSES.includes(course)) return { error: "Please select your course" };
    if (!COLLEGE_YEARS.includes(year)) return { error: "Please select your year" };
    return { education_type: "college", standard: null, course, college_year: year };
  }
  return { error: "Please choose School or College" };
}

// Which subjects a student gets:
//  - Class 1-8:  Science is one subject
//  - Class 9-12: Science splits into Physics, Chemistry, Biology
//  - BCA:        GK, Current Affairs, Maths + 7 computer subjects
export function subjectsFor(profile) {
  if (profile?.education_type === "school" && profile.standard) {
    return profile.standard <= 8
      ? ["gk", "current_affairs", "maths", "science"]
      : ["gk", "current_affairs", "maths", "physics", "chemistry", "biology"];
  }
  if (profile?.education_type === "college" && profile.course === "BCA") {
    return [
      "gk", "current_affairs", "maths",
      "dbms", "java", "oops", "cpp", "cloud", "ebusiness", "dccn",
    ];
  }
  return [];
}

// ---------- Teacher quiz audience (Phase 7) ----------

// Turns a quiz's target columns into the same shape as a student profile,
// so subjectsFor() / levelLabel() can be reused.
export function quizTargetAsProfile(quiz) {
  return {
    education_type: quiz.target_education_type,
    standard: quiz.target_standard,
    course: quiz.target_course,
    college_year: quiz.target_college_year,
  };
}

// e.g. "Class 7 · Science", "BCA 2nd year · DBMS", "BCA (all years) · Java"
export function audienceLabel(quiz) {
  if (!quiz?.subject) return null;
  const subject = SUBJECTS[quiz.subject]?.name ?? quiz.subject;
  if (quiz.target_education_type === "school")
    return `Class ${quiz.target_standard} · ${subject}`;
  const year = quiz.target_college_year
    ? `${ordinal(quiz.target_college_year)} year`
    : "(all years)";
  return `${quiz.target_course} ${year} · ${subject}`;
}

// Reads the <AudienceFields> inputs -> quiz columns, or { error }
export function readAudience(formData) {
  const type = formData.get("target_education_type");
  const subject = String(formData.get("subject") || "");
  let target;

  if (type === "school") {
    const standard = Number(formData.get("target_standard"));
    if (!Number.isInteger(standard) || standard < 1 || standard > 12)
      return { error: "Choose the class this quiz is for" };
    target = {
      target_education_type: "school",
      target_standard: standard,
      target_course: null,
      target_college_year: null,
    };
  } else if (type === "college") {
    const course = String(formData.get("target_course") || "");
    const yearRaw = String(formData.get("target_college_year") || "all");
    const year = yearRaw === "all" ? null : Number(yearRaw);
    if (!COURSES.includes(course)) return { error: "Choose the course this quiz is for" };
    if (year !== null && !COLLEGE_YEARS.includes(year))
      return { error: "Choose the year this quiz is for" };
    target = {
      target_education_type: "college",
      target_standard: null,
      target_course: course,
      target_college_year: year,
    };
  } else {
    return { error: "Choose School or College for this quiz" };
  }

  // The subject must exist at that level (e.g. no Physics for Class 5)
  if (!subjectsFor(quizTargetAsProfile(target)).includes(subject))
    return { error: "Choose a subject that belongs to that class/course" };

  return { subject, ...target };
}

// Applies "questions for MY level" to a Supabase query on practice_questions.
// School: question range must include my standard (e.g. 3-5 includes 4).
// College: question's course must match mine (shared by all years).
export function filterPracticeForLevel(query, profile) {
  if (profile.education_type === "school") {
    return query
      .eq("education_type", "school")
      .lte("min_standard", profile.standard)
      .gte("max_standard", profile.standard);
  }
  return query.eq("education_type", "college").eq("course", profile.course);
}

// Fisher-Yates shuffle (returns a new array, original untouched)
export function shuffle(items) {
  const arr = [...items];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

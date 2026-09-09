"use client";

import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { findLesson } from "@/lib/demo-data";
import { isLessonComplete, markLessonComplete } from "@/lib/progress";

export default function LessonPage() {
  const params = useParams<{ courseId: string; lessonId: string }>();
  const router = useRouter();
  const found = findLesson(params.courseId, params.lessonId);
  const [done, setDone] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  useEffect(() => {
    if (found) {
      setDone(Boolean(found.lesson.completed) || isLessonComplete(found.lesson.id));
    }
  }, [found]);

  if (!found) {
    return (
      <main className="page">
        <p>Lesson not found.</p>
        <Link href="/learn/courses">Back to courses</Link>
      </main>
    );
  }

  const { course, module, lesson } = found;

  function complete() {
    markLessonComplete(lesson.id);
    setDone(true);
    setToast("Progress saved");
    setTimeout(() => setToast(null), 2200);
  }

  return (
    <main className="page">
      <Link href={`/learn/courses/${course.id}`} className="eyebrow">
        ← {course.title}
      </Link>
      <p className="muted" style={{ marginTop: 8, fontSize: "0.82rem" }}>
        {module.title}
      </p>
      <h1 style={{ fontSize: "1.65rem", marginTop: 4 }}>{lesson.title}</h1>
      <p className="muted" style={{ marginTop: 6 }}>
        {lesson.lessonType.replace("_", " ")} · {lesson.estimatedMinutes} min
      </p>

      {lesson.lessonType === "video" ? (
        <div className="video-stage rise">
          <button type="button" className="play-orb" aria-label="Play approved video">
            ▶
          </button>
        </div>
      ) : null}

      <article className="surface markdown rise-delay" style={{ padding: 16, marginTop: 14 }}>
        {lesson.bodyMarkdown.split("\n\n").map((para) => (
          <p key={para.slice(0, 24)}>{para}</p>
        ))}
        {lesson.lessonType === "video" ? (
          <p className="muted" style={{ marginTop: 14, fontSize: "0.86rem" }}>
            External content stays on its source. Attribution and an open-in-browser path are shown before launch.
          </p>
        ) : null}
      </article>

      <div className="cta-row rise-delay-2">
        <button
          type="button"
          className="btn btn-primary"
          onClick={complete}
          disabled={done}
        >
          {done ? "Completed" : "Mark complete"}
        </button>
        <button
          type="button"
          className="btn"
          onClick={() => router.push(`/learn/courses/${course.id}`)}
        >
          Back to module
        </button>
      </div>

      {toast ? <div className="toast">{toast}</div> : null}
    </main>
  );
}

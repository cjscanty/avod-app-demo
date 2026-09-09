import Link from "next/link";
import { notFound } from "next/navigation";
import { findCourse } from "@/lib/demo-data";

export default async function CourseDetailPage({
  params,
}: {
  params: Promise<{ courseId: string }>;
}) {
  const { courseId } = await params;
  const course = findCourse(courseId);
  if (!course) notFound();

  return (
    <main className="page">
      <Link href="/learn/courses" className="eyebrow">
        ← Courses
      </Link>
      <h1 style={{ fontSize: "1.7rem", marginTop: 8 }}>{course.title}</h1>
      <p className="section-sub">{course.description}</p>
      <div className="progress-track" style={{ marginBottom: 20 }}>
        <div className="progress-fill" style={{ width: `${course.progressPercent}%` }} />
      </div>
      <div className="stack">
        {course.modules.map((mod) => (
          <section key={mod.id} className="surface" style={{ padding: 14 }}>
            <h2 style={{ fontSize: "1.15rem" }}>{mod.title}</h2>
            <p className="muted" style={{ marginTop: 4, marginBottom: 12, fontSize: "0.88rem" }}>
              {mod.description}
            </p>
            <div className="stack">
              {mod.lessons.map((lesson) => (
                <Link
                  key={lesson.id}
                  href={`/learn/courses/${course.id}/lessons/${lesson.id}`}
                  className="list-link"
                  style={{ padding: 12 }}
                >
                  <div style={{ flex: 1 }}>
                    <strong>{lesson.title}</strong>
                    <p className="muted" style={{ fontSize: "0.8rem", marginTop: 4 }}>
                      {lesson.lessonType.replace("_", " ")} · {lesson.estimatedMinutes} min
                      {lesson.completed ? " · Done" : ""}
                    </p>
                  </div>
                  <span aria-hidden>{lesson.completed ? "✓" : "→"}</span>
                </Link>
              ))}
            </div>
          </section>
        ))}
      </div>
    </main>
  );
}

import Link from "next/link";
import {
  demoAnnouncements,
  demoCourses,
  demoLearner,
  demoTodos,
  kingdomTheme,
} from "@/lib/demo-data";

export default function LearnHomePage() {
  const nextCourse = demoCourses[0];
  const nextLesson = nextCourse.modules[0].lessons.find((l) => !l.completed);

  return (
    <main className="page">
      <div className="row" style={{ marginBottom: 14 }}>
        <div>
          <p className="eyebrow">{kingdomTheme.displayName}</p>
          <h1 style={{ fontSize: "1.55rem", marginTop: 4 }}>Hi, {demoLearner.displayName.split(" ")[0]}</h1>
        </div>
        <span className="spacer" />
        <Link href="/learn/profile" className="chip">
          Learner
        </Link>
      </div>

      <section className="hero-panel rise">
        <p className="eyebrow" style={{ color: "rgba(244,247,239,0.65)" }}>
          Up next
        </p>
        <h2 style={{ fontSize: "1.75rem", marginTop: 8, maxWidth: 320 }}>
          {nextLesson?.title ?? "You are caught up"}
        </h2>
        <p style={{ marginTop: 8, color: "rgba(244,247,239,0.78)", maxWidth: 340 }}>
          {nextCourse.title} · {nextLesson?.estimatedMinutes ?? 0} min
        </p>
        <div className="cta-row">
          {nextLesson ? (
            <Link
              className="btn btn-primary"
              href={`/learn/courses/${nextCourse.id}/lessons/${nextLesson.id}`}
            >
              Continue lesson
            </Link>
          ) : null}
        </div>
      </section>

      <section className="rise-delay" style={{ marginTop: 22 }}>
        <h2 className="section-title">Your courses</h2>
        <p className="section-sub">Published learning paths in {kingdomTheme.shortName}.</p>
        <div className="stack">
          {demoCourses.map((course) => (
            <Link
              key={course.id}
              href={`/learn/courses/${course.id}`}
              className="list-link"
            >
              <div style={{ flex: 1 }}>
                <div className="row">
                  <strong>{course.title}</strong>
                  <span className="spacer" />
                  <span className="muted" style={{ fontSize: "0.8rem" }}>
                    {course.progressPercent}%
                  </span>
                </div>
                <p className="muted" style={{ fontSize: "0.86rem", marginTop: 4 }}>
                  {course.category}
                </p>
                <div className="progress-track" style={{ marginTop: 10 }}>
                  <div
                    className="progress-fill"
                    style={{ width: `${course.progressPercent}%` }}
                  />
                </div>
              </div>
            </Link>
          ))}
        </div>
      </section>

      <section className="rise-delay-2" style={{ marginTop: 22 }}>
        <h2 className="section-title">To-do</h2>
        <p className="section-sub">Due work and next actions.</p>
        <div className="stack">
          {demoTodos.slice(0, 2).map((todo) => (
            <Link key={todo.id} href={todo.href} className="list-link">
              <div>
                <strong>{todo.title}</strong>
                <p className="muted" style={{ fontSize: "0.84rem", marginTop: 4 }}>
                  {todo.courseTitle} · {todo.dueLabel}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </section>

      <section style={{ marginTop: 22 }}>
        <h2 className="section-title">Announcement</h2>
        <div className="surface" style={{ padding: 14, marginTop: 8 }}>
          <strong>{demoAnnouncements[0].title}</strong>
          <p className="muted" style={{ marginTop: 6, lineHeight: 1.45 }}>
            {demoAnnouncements[0].body}
          </p>
        </div>
      </section>
    </main>
  );
}

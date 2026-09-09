import { ParentShell } from "@/components/ParentShell";
import { demoCourses } from "@/lib/demo-data";

export default function ParentCoursesPage() {
  return (
    <ParentShell active="/parent/courses">
      <p className="eyebrow">Authoring</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Courses</h1>
      <p className="section-sub">
        Draft, publish, pause, and archive. Learners only see published content.
      </p>
      <div className="stack">
        {demoCourses.map((course) => (
          <article key={course.id} className="surface" style={{ padding: 16 }}>
            <div className="row">
              <h2 style={{ fontSize: "1.2rem" }}>{course.title}</h2>
              <span className="spacer" />
              <span className="chip">{course.status}</span>
            </div>
            <p className="muted" style={{ marginTop: 8, lineHeight: 1.45 }}>
              {course.description}
            </p>
            <p style={{ marginTop: 10, fontSize: "0.86rem" }}>
              {course.modules.length} modules · {course.modules.reduce((n, m) => n + m.lessons.length, 0)} lessons
            </p>
          </article>
        ))}
      </div>
    </ParentShell>
  );
}

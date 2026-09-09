import Link from "next/link";
import { ParentShell } from "@/components/ParentShell";
import { demoCourses, demoTodos } from "@/lib/demo-data";

export default function ParentDashboard() {
  return (
    <ParentShell active="/parent">
      <p className="eyebrow">Kingdom Preparatory</p>
      <h1 style={{ fontSize: "1.9rem", marginTop: 4 }}>Classroom dashboard</h1>
      <p className="section-sub">
        Build courses, review AI drafts, grade work, and keep the community safe.
      </p>

      <div className="stat-grid">
        <div className="stat">
          <span className="muted">Courses</span>
          <strong>{demoCourses.length}</strong>
        </div>
        <div className="stat">
          <span className="muted">Learners</span>
          <strong>2</strong>
        </div>
        <div className="stat">
          <span className="muted">Open to-dos</span>
          <strong>{demoTodos.length}</strong>
        </div>
        <div className="stat">
          <span className="muted">Reports</span>
          <strong>1</strong>
        </div>
      </div>

      <section style={{ marginTop: 22 }}>
        <h2 className="section-title">Quick actions</h2>
        <div className="cta-row">
          <Link className="btn btn-primary" href="/parent/builder">
            Start Curriculum Builder
          </Link>
          <Link className="btn" href="/parent/courses">
            Manage courses
          </Link>
          <Link className="btn" href="/learn">
            Preview learner
          </Link>
        </div>
      </section>

      <section style={{ marginTop: 22 }}>
        <h2 className="section-title">Published courses</h2>
        <div className="stack" style={{ marginTop: 10 }}>
          {demoCourses.map((course) => (
            <div key={course.id} className="list-link">
              <div style={{ flex: 1 }}>
                <strong>{course.title}</strong>
                <p className="muted" style={{ marginTop: 4, fontSize: "0.86rem" }}>
                  {course.status} · {course.category}
                </p>
              </div>
            </div>
          ))}
        </div>
      </section>
    </ParentShell>
  );
}

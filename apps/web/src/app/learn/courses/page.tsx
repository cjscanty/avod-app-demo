import Link from "next/link";
import { demoCourses } from "@/lib/demo-data";

export default function CoursesPage() {
  return (
    <main className="page">
      <p className="eyebrow">Learning</p>
      <h1 style={{ fontSize: "1.7rem", marginTop: 4 }}>Courses</h1>
      <p className="section-sub">Everything published for your classroom.</p>
      <div className="stack">
        {demoCourses.map((course) => (
          <Link key={course.id} href={`/learn/courses/${course.id}`} className="list-link">
            <div style={{ flex: 1 }}>
              <div className="chip" style={{ marginBottom: 8 }}>
                {course.category}
              </div>
              <strong style={{ fontSize: "1.05rem" }}>{course.title}</strong>
              <p className="muted" style={{ marginTop: 6, lineHeight: 1.45, fontSize: "0.9rem" }}>
                {course.description}
              </p>
              <div className="progress-track" style={{ marginTop: 12 }}>
                <div className="progress-fill" style={{ width: `${course.progressPercent}%` }} />
              </div>
            </div>
          </Link>
        ))}
      </div>
    </main>
  );
}

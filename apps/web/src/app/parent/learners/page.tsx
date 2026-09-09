import { ParentShell } from "@/components/ParentShell";

export default function ParentLearnersPage() {
  return (
    <ParentShell active="/parent/learners">
      <p className="eyebrow">Enrollment</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Learners</h1>
      <p className="section-sub">Invite by secure link or email. Minors are created by authorized adults.</p>
      <div className="stack">
        {[
          { name: "Tamika Hale", status: "active", courses: 3 },
          { name: "Noah Okonkwo", status: "active", courses: 3 },
        ].map((learner) => (
          <div key={learner.name} className="list-link">
            <div>
              <strong>{learner.name}</strong>
              <p className="muted" style={{ marginTop: 4, fontSize: "0.86rem" }}>
                {learner.status} · {learner.courses} courses
              </p>
            </div>
          </div>
        ))}
      </div>
    </ParentShell>
  );
}

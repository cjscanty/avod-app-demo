import { ParentShell } from "@/components/ParentShell";

export default function GradebookPage() {
  return (
    <ParentShell active="/parent/gradebook">
      <p className="eyebrow">Assessment</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Gradebook</h1>
      <p className="section-sub">Unified scores across assignments, quizzes, and excused work.</p>
      <div className="surface" style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: "0.92rem" }}>
          <thead>
            <tr>
              <th style={{ textAlign: "left", padding: 12, borderBottom: "1px solid var(--avod-border)" }}>Learner</th>
              <th style={{ textAlign: "left", padding: 12, borderBottom: "1px solid var(--avod-border)" }}>Activity</th>
              <th style={{ textAlign: "left", padding: 12, borderBottom: "1px solid var(--avod-border)" }}>Score</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style={{ padding: 12, borderBottom: "1px solid var(--avod-border)" }}>Tamika Hale</td>
              <td style={{ padding: 12, borderBottom: "1px solid var(--avod-border)" }}>Stewardship Basics quiz</td>
              <td style={{ padding: 12, borderBottom: "1px solid var(--avod-border)" }}>5 / 10</td>
            </tr>
            <tr>
              <td style={{ padding: 12 }}>Tamika Hale</td>
              <td style={{ padding: 12 }}>Needs Interview Notes</td>
              <td style={{ padding: 12 }}>Submitted</td>
            </tr>
          </tbody>
        </table>
      </div>
    </ParentShell>
  );
}

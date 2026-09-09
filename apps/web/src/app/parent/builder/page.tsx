"use client";

import { useState } from "react";
import { ParentShell } from "@/components/ParentShell";

export default function CurriculumBuilderPage() {
  const [topic, setTopic] = useState("Kingdom Business");
  const [submitted, setSubmitted] = useState(false);

  return (
    <ParentShell active="/parent/builder">
      <p className="eyebrow">AI-assisted · parent-approved</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Curriculum Builder</h1>
      <p className="section-sub">
        AI drafts stay invisible to learners until you review, edit, and publish.
      </p>

      <form
        className="surface stack"
        style={{ padding: 16, maxWidth: 560 }}
        onSubmit={(e) => {
          e.preventDefault();
          setSubmitted(true);
        }}
      >
        <div className="form-field">
          <label htmlFor="topic">Course topic</label>
          <input id="topic" value={topic} onChange={(e) => setTopic(e.target.value)} required />
        </div>
        <div className="form-field">
          <label htmlFor="age">Age / grade</label>
          <input id="age" defaultValue="Ages 11–14" />
        </div>
        <div className="form-field">
          <label htmlFor="values">Values / worldview preferences</label>
          <textarea id="values" rows={3} defaultValue="Christian stewardship, service, ethical trade" />
        </div>
        <div className="form-field">
          <label htmlFor="goals">Learning goals</label>
          <textarea id="goals" rows={3} defaultValue="Launch a micro-venture; practice budgeting; reflect on stewardship" />
        </div>
        <p className="muted" style={{ fontSize: "0.84rem", lineHeight: 1.45 }}>
          AI content may be inaccurate and requires your review. Provider keys stay server-side.
        </p>
        <button type="submit" className="btn btn-primary">
          Queue generation job
        </button>
      </form>

      {submitted ? (
        <div className="surface" style={{ padding: 16, marginTop: 16, maxWidth: 560 }}>
          <strong>Job queued</strong>
          <p className="muted" style={{ marginTop: 6, lineHeight: 1.45 }}>
            Status: review_ready (demo). When Supabase + jobs are wired, this creates an <code>ai_jobs</code> row and structured <code>ai_artifacts</code> for approval.
          </p>
          <ul style={{ margin: "12px 0 0", paddingLeft: 18, lineHeight: 1.55 }}>
            <li>Draft module: Foundations of Stewardship</li>
            <li>Draft module: Your First Micro-Venture</li>
            <li>Suggested resource search: Indian Ocean trade for ages 11–14</li>
          </ul>
        </div>
      ) : null}
    </ParentShell>
  );
}

import { ParentShell } from "@/components/ParentShell";

export default function ParentCommunityPage() {
  return (
    <ParentShell active="/parent/community">
      <p className="eyebrow">Safety</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Community & moderation</h1>
      <p className="section-sub">Private classroom feed with report queue and auditable actions.</p>
      <div className="surface" style={{ padding: 16 }}>
        <strong>Open report</strong>
        <p className="muted" style={{ marginTop: 6, lineHeight: 1.45 }}>
          Demo: comment from Noah flagged as “other” for moderator review. Disposition requires a reason and is written to moderation_actions + audit_logs.
        </p>
        <div className="cta-row">
          <button type="button" className="btn btn-primary">No violation</button>
          <button type="button" className="btn">Hide</button>
          <button type="button" className="btn">Warn</button>
        </div>
      </div>
    </ParentShell>
  );
}

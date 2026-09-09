import { ParentShell } from "@/components/ParentShell";
import { isSupabaseConfigured } from "@/lib/supabase/client";

export default function SettingsPage() {
  return (
    <ParentShell active="/parent/settings">
      <p className="eyebrow">Organization</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Settings</h1>
      <p className="section-sub">Tenant configuration, data export requests, and environment status.</p>
      <div className="surface stack" style={{ padding: 16, maxWidth: 560 }}>
        <div>
          <p className="eyebrow">Backend</p>
          <strong>{isSupabaseConfigured() ? "Supabase configured" : "Demo mode (no Supabase env)"}</strong>
        </div>
        <div>
          <p className="eyebrow">Migrations</p>
          <p className="muted" style={{ lineHeight: 1.45 }}>
            Apply <code>supabase/migrations</code> then run <code>seed/kingdom_preparatory.sql</code> after creating auth users.
          </p>
        </div>
      </div>
    </ParentShell>
  );
}

"use client";

import { useState } from "react";
import { ParentShell } from "@/components/ParentShell";
import { kingdomTheme } from "@/lib/demo-data";

export default function BrandStudioPage() {
  const [primary, setPrimary] = useState(kingdomTheme.primaryColor);
  const [secondary, setSecondary] = useState(kingdomTheme.secondaryColor);
  const [accent, setAccent] = useState(kingdomTheme.accentColor);

  return (
    <ParentShell active="/parent/brand">
      <p className="eyebrow">Brand Studio</p>
      <h1 style={{ fontSize: "1.8rem", marginTop: 4 }}>Classroom theme</h1>
      <p className="section-sub">
        Draft and published themes are distinct. AVOD accent remains for platform chrome; tenant colors theme classroom surfaces.
      </p>

      <div className="grid-2">
        <form className="surface stack" style={{ padding: 16 }}>
          <div className="form-field">
            <label htmlFor="primary">Primary</label>
            <input id="primary" type="color" value={primary} onChange={(e) => setPrimary(e.target.value)} />
          </div>
          <div className="form-field">
            <label htmlFor="secondary">Secondary</label>
            <input id="secondary" type="color" value={secondary} onChange={(e) => setSecondary(e.target.value)} />
          </div>
          <div className="form-field">
            <label htmlFor="accent">Accent</label>
            <input id="accent" type="color" value={accent} onChange={(e) => setAccent(e.target.value)} />
          </div>
          <button type="button" className="btn btn-primary">Save draft theme</button>
        </form>

        <div
          className="hero-panel"
          style={{
            ["--tenant-primary" as string]: primary,
            background: `linear-gradient(160deg, ${primary} 0%, #0f241c 58%, #173329 100%)`,
          }}
        >
          <p className="eyebrow" style={{ color: "rgba(244,247,239,0.65)" }}>Mobile preview</p>
          <h2 style={{ fontSize: "1.6rem", marginTop: 8 }}>{kingdomTheme.displayName}</h2>
          <p style={{ marginTop: 8, color: "rgba(244,247,239,0.78)" }}>Learner home hero with classroom colors.</p>
          <div className="cta-row">
            <span className="btn btn-primary" style={{ background: accent, borderColor: accent }}>
              Continue lesson
            </span>
          </div>
        </div>
      </div>
    </ParentShell>
  );
}

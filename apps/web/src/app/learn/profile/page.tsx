"use client";

import Link from "next/link";
import { demoLearner, kingdomTheme } from "@/lib/demo-data";
import { clearProgress } from "@/lib/progress";
import { isSupabaseConfigured } from "@/lib/supabase/client";

export default function ProfilePage() {
  return (
    <main className="page">
      <p className="eyebrow">Account</p>
      <h1 style={{ fontSize: "1.7rem", marginTop: 4 }}>{demoLearner.displayName}</h1>
      <p className="section-sub">
        Learner in {kingdomTheme.displayName} · {kingdomTheme.academicYear}
      </p>

      <div className="surface stack" style={{ padding: 16 }}>
        <div>
          <p className="eyebrow">Classroom</p>
          <strong>{kingdomTheme.displayName}</strong>
          <p className="muted" style={{ marginTop: 4 }}>{kingdomTheme.ageGradeRange}</p>
        </div>
        <div>
          <p className="eyebrow">Data mode</p>
          <strong>{isSupabaseConfigured() ? "Supabase connected" : "Local demo seed"}</strong>
          <p className="muted" style={{ marginTop: 4, fontSize: "0.86rem", lineHeight: 1.45 }}>
            Set NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY, then run migrations in /supabase.
          </p>
        </div>
        <button
          type="button"
          className="btn"
          onClick={() => {
            clearProgress();
            alert("Local progress cleared.");
          }}
        >
          Reset local progress
        </button>
        <Link className="btn btn-dark" href="/">
          Back to AVOD home
        </Link>
      </div>
    </main>
  );
}

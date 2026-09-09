import Link from "next/link";

export default function HomePage() {
  return (
    <main className="landing-hero">
      <p className="eyebrow" style={{ color: "rgba(244,247,239,0.7)" }}>
        Homeschool learning platform
      </p>
      <h1 className="brand-mark rise" style={{ marginTop: 10 }}>
        AVOD
      </h1>
      <p className="rise-delay" style={{ marginTop: 14, fontSize: "1.25rem", lineHeight: 1.35, maxWidth: 420 }}>
        Turn an educational idea into a safe, branded classroom — parents lead, AI assists, learners thrive on mobile.
      </p>
      <p className="rise-delay-2 muted" style={{ marginTop: 12, color: "rgba(244,247,239,0.72)", maxWidth: 440 }}>
        Kingdom Preparatory is the reference classroom. Multi-tenant isolation, Supabase auth & RLS, and a five-tab learner app.
      </p>
      <div className="cta-row rise-delay-2">
        <Link className="btn btn-primary" href="/learn">
          Open learner app
        </Link>
        <Link className="btn" href="/parent" style={{ background: "rgba(255,255,255,0.08)", color: "#f4f7ef", borderColor: "rgba(255,255,255,0.25)" }}>
          Parent portal
        </Link>
      </div>
    </main>
  );
}

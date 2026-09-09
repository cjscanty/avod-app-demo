import { demoPosts } from "@/lib/demo-data";

export default function CommunityPage() {
  return (
    <main className="page">
      <p className="eyebrow">KP Village Square</p>
      <h1 style={{ fontSize: "1.7rem", marginTop: 4 }}>Community</h1>
      <p className="section-sub">
        Private to your classroom. Report anything that feels off — adults moderate.
      </p>
      <div className="stack">
        {demoPosts.map((post) => (
          <article key={post.id} className="surface" style={{ padding: 14 }}>
            <div className="row">
              <strong>{post.author}</strong>
              <span className="spacer" />
              <span className="muted" style={{ fontSize: "0.8rem" }}>
                {post.when}
              </span>
            </div>
            <p style={{ marginTop: 8, lineHeight: 1.5 }}>{post.body}</p>
            <div className="row" style={{ marginTop: 12 }}>
              <button type="button" className="btn btn-sm btn-ghost" style={{ minHeight: 40 }}>
                React
              </button>
              <button type="button" className="btn btn-sm btn-ghost" style={{ minHeight: 40 }}>
                Report
              </button>
            </div>
          </article>
        ))}
      </div>
    </main>
  );
}

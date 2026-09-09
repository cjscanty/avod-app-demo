import Link from "next/link";
import type { ReactNode } from "react";

const links = [
  { href: "/parent", label: "Dashboard" },
  { href: "/parent/courses", label: "Courses" },
  { href: "/parent/builder", label: "Curriculum Builder" },
  { href: "/parent/learners", label: "Learners" },
  { href: "/parent/gradebook", label: "Gradebook" },
  { href: "/parent/community", label: "Community" },
  { href: "/parent/brand", label: "Brand Studio" },
  { href: "/parent/settings", label: "Settings" },
];

export function ParentShell({
  children,
  active,
}: {
  children: ReactNode;
  active: string;
}) {
  return (
    <div className="parent-shell">
      <aside className="parent-side">
        <div style={{ padding: "4px 12px 18px" }}>
          <div className="eyebrow">AVOD</div>
          <strong style={{ fontFamily: "var(--avod-font-display)", fontSize: "1.35rem" }}>
            Parent portal
          </strong>
          <p className="muted" style={{ fontSize: "0.8rem", marginTop: 4 }}>
            Kingdom Preparatory
          </p>
        </div>
        {links.map((link) => (
          <Link
            key={link.href}
            href={link.href}
            className={active === link.href ? "active" : undefined}
          >
            {link.label}
          </Link>
        ))}
        <div style={{ marginTop: "auto", padding: 12 }}>
          <Link className="btn btn-ghost" href="/learn" style={{ width: "100%" }}>
            Learner app
          </Link>
        </div>
      </aside>
      <div className="parent-main">
        <div className="row" style={{ marginBottom: 16, gap: 8, flexWrap: "wrap" }}>
          {links.slice(0, 5).map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className="chip"
              style={{
                background:
                  active === link.href ? "rgba(199,240,0,0.4)" : "rgba(27,58,46,0.08)",
              }}
            >
              {link.label}
            </Link>
          ))}
        </div>
        {children}
      </div>
    </div>
  );
}

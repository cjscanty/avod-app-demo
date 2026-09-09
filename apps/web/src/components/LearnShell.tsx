"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import { kingdomTheme } from "@/lib/demo-data";

const tabs = [
  { href: "/learn", label: "Home", icon: "⌂" },
  { href: "/learn/courses", label: "Courses", icon: "▣" },
  { href: "/learn/todo", label: "To-Do", icon: "✓" },
  { href: "/learn/community", label: "Community", icon: "◎" },
  { href: "/learn/profile", label: "Profile", icon: "◯" },
];

export function LearnShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();

  return (
    <div
      className="app-shell"
      style={
        {
          "--tenant-primary": kingdomTheme.primaryColor,
          "--tenant-secondary": kingdomTheme.secondaryColor,
          "--tenant-accent": kingdomTheme.accentColor,
        } as React.CSSProperties
      }
    >
      <nav className="desktop-nav" aria-label="Learner">
        {tabs.map((tab) => {
          const active =
            tab.href === "/learn"
              ? pathname === "/learn"
              : pathname.startsWith(tab.href);
          return (
            <Link key={tab.href} href={tab.href} className={active ? "active" : undefined}>
              {tab.label}
            </Link>
          );
        })}
        <span className="spacer" />
        <Link href="/parent">Parent portal</Link>
      </nav>
      {children}
      <nav className="bottom-nav" aria-label="Primary">
        <div className="bottom-nav-inner">
          {tabs.map((tab) => {
            const active =
              tab.href === "/learn"
                ? pathname === "/learn"
                : pathname.startsWith(tab.href);
            return (
              <Link
                key={tab.href}
                href={tab.href}
                className={`nav-item${active ? " active" : ""}`}
              >
                <span aria-hidden>{tab.icon}</span>
                <span>{tab.label}</span>
              </Link>
            );
          })}
        </div>
      </nav>
    </div>
  );
}

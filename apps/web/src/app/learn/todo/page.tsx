import Link from "next/link";
import { demoTodos } from "@/lib/demo-data";

export default function TodoPage() {
  return (
    <main className="page">
      <p className="eyebrow">Planning</p>
      <h1 style={{ fontSize: "1.7rem", marginTop: 4 }}>To-Do</h1>
      <p className="section-sub">Prioritized work with due dates and deep links.</p>
      <div className="stack">
        {demoTodos.map((todo) => (
          <Link key={todo.id} href={todo.href} className="list-link">
            <div style={{ flex: 1 }}>
              <div className="row">
                <strong>{todo.title}</strong>
                <span className="spacer" />
                <span className="chip">{todo.dueLabel}</span>
              </div>
              <p className="muted" style={{ marginTop: 6, fontSize: "0.86rem" }}>
                {todo.courseTitle} · {todo.status}
              </p>
            </div>
          </Link>
        ))}
      </div>
    </main>
  );
}

# AVOD

Multi-tenant homeschool learning platform — parent portal + mobile-first learner experience, with PostgreSQL/Supabase as the system of record.

This repository redesigns the former single-file localStorage demo into the SRS baseline stack (Phase 0 foundation + Phase 1 vertical slice).

## Quick start

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

- **Learner app (mobile-first):** `/learn` — Home, Courses, To-Do, Community, Profile
- **Parent portal:** `/parent` — Dashboard, Courses, Curriculum Builder, Brand Studio, etc.

Without Supabase env vars the UI runs on Kingdom Preparatory **demo seed** data.

## Supabase

1. Create a Supabase project.
2. Apply migrations in order:

```bash
supabase db push
# or run SQL files in supabase/migrations via the SQL editor
```

3. Copy `apps/web/.env.example` → `apps/web/.env.local` and set:

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
```

4. Create auth users matching seed UUIDs (or adapt the seed), then:

```sql
select public.seed_kingdom_preparatory();
```

Schema covers organizations, classrooms, themes, courses, modules, lessons, AI jobs/artifacts, resources, assignments, quizzes, gradebook, progress, calendar, community, moderation, notifications, files, and audit logs — with RLS policies for tenant isolation.

## Brand

AVOD accent `#C7F000` with ink `#171A17` and canvas `#F7F8F5` (SRS §13.3). Classroom themes (e.g. Kingdom Preparatory) override tenant visual tokens without removing AVOD attribution or safety controls.

## Docs

- `docs/architecture/phase-0.md`
- `docs/decisions/0001-supabase.md`
- `docs/api/vertical-slice.md`
- `docs/legacy-demo.html` — previous static demo

## Scripts

| Command | Description |
|---|---|
| `npm run dev` | Next.js web app |
| `npm run build` | Production build |
| `npm run typecheck` | TypeScript check |

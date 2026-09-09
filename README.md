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

1. Create a Supabase project (or use an existing one).
2. Copy connection values into `apps/web/.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...   # server only
SUPABASE_DB_URL=postgresql://postgres.[ref]:[password]@...:5432/postgres
```

3. Apply the schema:

```bash
export SUPABASE_DB_URL='postgresql://...'
./scripts/apply-supabase.sh
```

Or with the CLI (`SUPABASE_ACCESS_TOKEN` + `SUPABASE_PROJECT_REF`):

```bash
./scripts/supabase-cli-push.sh
```

4. After creating matching auth users (or adapting seed UUIDs):

```bash
RUN_SEED=1 ./scripts/apply-supabase.sh
# or: select public.seed_kingdom_preparatory();
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

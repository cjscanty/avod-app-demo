# AVOD Phase 0 Architecture

## Decisions (temporary assumptions from SRS §20)

1. **Customers:** Families, cooperatives, and micro-schools (multi-tenant from day one).
2. **Classrooms:** One organization may operate multiple independently branded classrooms.
3. **Learners:** Primarily minors; adult learners supported later via `is_minor=false`.
4. **Faith/values:** Both tenant-wide (`curriculum_preferences`) and course-specific AI inputs.
5. **Billing:** Not enforced in Phase 1; `plan_code` stored for later.
6. **Grades:** Informal family progress records in MVP; exportable later.

## Stack

| Layer | Choice |
|---|---|
| Web | Next.js App Router (TypeScript strict) |
| Mobile | Expo app deferred; learner web is mobile-first (Phase 1) |
| DB / Auth / Storage | Supabase (PostgreSQL + RLS) |
| Validation | Zod shared schemas |
| Demo | Seeded Kingdom Preparatory data without live Supabase |

## Phase 1 vertical slice

Organization → branded classroom → course/module/video lesson → enroll learner → complete lesson → progress event → tenant isolation via RLS.

## Security

- Every tenant table includes `organization_id`.
- RLS helpers: `is_org_member`, `has_org_role`, `is_classroom_member`.
- AI artifacts and resource candidates are adult-only.
- Learners see only published courses/modules/lessons and their own grades/submissions.

## Repository

```
apps/web                 Next.js parent + learner surfaces
packages/design-tokens   AVOD brand tokens
packages/schemas         Shared Zod contracts
packages/auth            Role helpers
supabase/migrations      Schema + RLS
supabase/seed            Kingdom Preparatory seed
docs/                    Architecture & ADRs
```

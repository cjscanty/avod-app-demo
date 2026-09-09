# Vertical slice API (Phase 1)

Base path: `/v1`

## Auth
- `POST /v1/auth/sign-in`
- `POST /v1/auth/sign-out`

## Tenancy
- `POST /v1/organizations`
- `POST /v1/classrooms`
- `POST /v1/classrooms/:id/themes`
- `POST /v1/memberships/invitations`

## Curriculum
- `POST /v1/courses`
- `POST /v1/courses/:id/modules`
- `POST /v1/modules/:id/lessons`
- `POST /v1/courses/:id/publish`
- `POST /v1/courses/:id/enrollments`

## Progress
- `POST /v1/progress/events` (idempotent via `event_key`)
- `GET /v1/progress/snapshots?courseId=`

Errors return `{ code, message, requestId }` and never leak cross-tenant identifiers.

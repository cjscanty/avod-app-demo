# ADR 0001 — Supabase as system of record

## Status

Accepted for Phase 0/1.

## Context

AVOD requires multi-tenant isolation, auth, file storage, and row-level security for a child-safety-sensitive LMS.

## Decision

Use Supabase (PostgreSQL) with versioned SQL migrations, RLS on all tenant tables, and server-side service role only for privileged jobs.

## Consequences

- Local/demo mode may run without live credentials using typed seed data in the web app.
- Background AI/resource jobs will live under `services/jobs` and call providers with server secrets only.
- Expo mobile will share the same schema via generated types in a later slice.

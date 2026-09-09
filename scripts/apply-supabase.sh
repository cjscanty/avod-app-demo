#!/usr/bin/env bash
# Apply AVOD migrations + seed to a remote Supabase Postgres database.
# Required env:
#   SUPABASE_DB_URL  — Session/Transaction pooler or direct connection string
#                      (Project Settings → Database → Connection string URI)
# Optional:
#   SKIP_SEED=1      — skip Kingdom Preparatory seed function install/run
#   RUN_SEED=1       — call seed_kingdom_preparatory() after install
#                      (requires matching auth.users rows first)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MIG="$ROOT/supabase/migrations"
SEED="$ROOT/supabase/seed/kingdom_preparatory.sql"

if [[ -z "${SUPABASE_DB_URL:-}" ]]; then
  echo "Missing SUPABASE_DB_URL."
  echo "From Supabase Dashboard → Project Settings → Database, copy the URI"
  echo "(prefer direct connection on port 5432, or session pooler)."
  echo "Example:"
  echo "  export SUPABASE_DB_URL='postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:5432/postgres'"
  exit 1
fi

if ! command -v psql >/dev/null 2>&1; then
  echo "psql is required. Install postgresql-client."
  exit 1
fi

echo "Applying migrations from $MIG"
for f in "$MIG"/*.sql; do
  echo "→ $(basename "$f")"
  psql "$SUPABASE_DB_URL" -v ON_ERROR_STOP=1 -f "$f"
done

if [[ "${SKIP_SEED:-0}" != "1" ]]; then
  echo "→ installing seed function"
  psql "$SUPABASE_DB_URL" -v ON_ERROR_STOP=1 -f "$SEED"
fi

if [[ "${RUN_SEED:-0}" == "1" ]]; then
  echo "→ running seed_kingdom_preparatory()"
  psql "$SUPABASE_DB_URL" -v ON_ERROR_STOP=1 -c "select public.seed_kingdom_preparatory();"
fi

echo "Done. AVOD schema is live on Supabase."

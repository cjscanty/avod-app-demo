#!/usr/bin/env bash
# Link / push using Supabase CLI when you have an access token + project ref.
# Required:
#   SUPABASE_ACCESS_TOKEN  — https://supabase.com/dashboard/account/tokens
#   SUPABASE_PROJECT_REF   — Project Settings → General → Reference ID
# Optional:
#   SUPABASE_DB_PASSWORD   — needed for some CLI db operations
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -z "${SUPABASE_ACCESS_TOKEN:-}" || -z "${SUPABASE_PROJECT_REF:-}" ]]; then
  echo "Set SUPABASE_ACCESS_TOKEN and SUPABASE_PROJECT_REF."
  exit 1
fi

npx supabase link --project-ref "$SUPABASE_PROJECT_REF"
npx supabase db push
echo "Migrations pushed via Supabase CLI."

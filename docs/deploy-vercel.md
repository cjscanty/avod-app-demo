# Deploy

## Option A — Claim the temporary deployment (fastest)

A temporary production build is live:

- App: https://temporary-turbo-reef-qoauryk.vercel.app
- Claim (keeps it under your Vercel account): https://vercel.com/claim-deployment?code=3ccbeb0a-54d7-429d-a1a5-f7238a9be766

Temporary deployments expire ~60 minutes unless claimed.

## Option B — Permanent project with a token

1. Create a token at https://vercel.com/account/tokens
2. In this environment:

```bash
export VERCEL_TOKEN=...
cd apps/web
npx vercel link --yes --token "$VERCEL_TOKEN"
npx vercel --prod --yes --token "$VERCEL_TOKEN"
```

Set Root Directory to `apps/web` if importing the GitHub repo in the Vercel dashboard.

Optional env vars:

```
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

import { NextResponse } from "next/server";
import { ProgressEventSchema } from "@avod/schemas";
import { isSupabaseConfigured } from "@/lib/supabase/client";

/** Idempotent progress write for the Phase 1 vertical slice. */
export async function POST(request: Request) {
  const json = await request.json().catch(() => null);
  const parsed = ProgressEventSchema.safeParse(json);
  if (!parsed.success) {
    return NextResponse.json(
      { code: "validation_error", message: "Invalid progress event", issues: parsed.error.flatten() },
      { status: 400 }
    );
  }

  if (!isSupabaseConfigured()) {
    return NextResponse.json({
      code: "demo_accepted",
      message: "Progress accepted in demo mode (no Supabase). Persist via client local store.",
      event: parsed.data,
    });
  }

  // Live path: insert into progress_events with on-conflict ignore, then upsert snapshot.
  return NextResponse.json({
    code: "accepted",
    message: "Wire authenticated Supabase insert in the next slice.",
    event: parsed.data,
  });
}

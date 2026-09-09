"use client";

const KEY = "avod_progress_v1";

type ProgressMap = Record<string, boolean>;

function read(): ProgressMap {
  if (typeof window === "undefined") return {};
  try {
    return JSON.parse(localStorage.getItem(KEY) || "{}") as ProgressMap;
  } catch {
    return {};
  }
}

function write(map: ProgressMap) {
  localStorage.setItem(KEY, JSON.stringify(map));
}

export function isLessonComplete(lessonId: string): boolean {
  return Boolean(read()[lessonId]);
}

export function markLessonComplete(lessonId: string) {
  const map = read();
  map[lessonId] = true;
  write(map);
  window.dispatchEvent(new Event("avod-progress"));
}

export function clearProgress() {
  localStorage.removeItem(KEY);
  window.dispatchEvent(new Event("avod-progress"));
}

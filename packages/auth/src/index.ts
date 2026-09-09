export type AppRole =
  | "avod_admin"
  | "org_owner"
  | "parent_instructor"
  | "learner"
  | "moderator"
  | "support_agent";

const adultRoles: AppRole[] = [
  "avod_admin",
  "org_owner",
  "parent_instructor",
  "moderator",
  "support_agent",
];

export function isAdultRole(role: AppRole): boolean {
  return adultRoles.includes(role);
}

export function canPublishCourse(role: AppRole): boolean {
  return role === "avod_admin" || role === "org_owner" || role === "parent_instructor";
}

export function canModerateCommunity(role: AppRole): boolean {
  return (
    role === "avod_admin" ||
    role === "org_owner" ||
    role === "parent_instructor" ||
    role === "moderator"
  );
}

export function canApproveAi(role: AppRole): boolean {
  return canPublishCourse(role);
}

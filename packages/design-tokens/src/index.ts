/** AVOD brand tokens (SRS §13.3) */
export const avodTokens = {
  accent: "#C7F000",
  primaryInk: "#171A17",
  secondaryInk: "#4B514A",
  canvas: "#F7F8F5",
  surface: "#FFFFFF",
  border: "#DDE1D9",
  error: "#B42318",
  warning: "#9A6700",
  success: "#137333",
  fonts: {
    display: '"Fraunces", "Source Serif 4", Georgia, serif',
    body: '"Sora", "Avenir Next", "Segoe UI", sans-serif',
  },
} as const;

export type ClassroomThemeTokens = {
  displayName: string;
  primaryColor: string;
  secondaryColor: string;
  accentColor: string;
  logoUrl?: string | null;
  bannerUrl?: string | null;
};

export function themeToCssVars(theme: ClassroomThemeTokens): Record<string, string> {
  return {
    "--tenant-name": `"${theme.displayName}"`,
    "--tenant-primary": theme.primaryColor,
    "--tenant-secondary": theme.secondaryColor,
    "--tenant-accent": theme.accentColor,
  };
}

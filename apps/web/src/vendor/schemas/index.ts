import { z } from "zod";

export const CourseDraftSchema = z.object({
  title: z.string().min(1),
  description: z.string().optional(),
  rationale: z.string().optional(),
  learning_outcomes: z.array(z.string()).default([]),
  assumptions: z.array(z.string()).default([]),
  safety_or_review_notes: z.array(z.string()).default([]),
  modules: z
    .array(
      z.object({
        title: z.string(),
        summary: z.string().optional(),
        objectives: z.array(z.string()).default([]),
        estimated_minutes: z.number().optional(),
        lessons: z
          .array(
            z.object({
              title: z.string(),
              lesson_type: z.enum([
                "rich_text",
                "video",
                "article",
                "file",
                "assignment",
                "quiz",
                "discussion",
                "mixed",
              ]),
              objective: z.string().optional(),
              instruction_summary: z.string().optional(),
              activity_idea: z.string().optional(),
              assessment_idea: z.string().optional(),
              resource_search_queries: z.array(z.string()).default([]),
            })
          )
          .default([]),
      })
    )
    .default([]),
});

export type CourseDraft = z.infer<typeof CourseDraftSchema>;

export const ProgressEventSchema = z.object({
  courseId: z.string().uuid(),
  moduleId: z.string().uuid().optional(),
  lessonId: z.string().uuid(),
  eventType: z.enum(["lesson_started", "lesson_completed"]),
  eventKey: z.string().default("default"),
});

export const CreateCourseInputSchema = z.object({
  classroomId: z.string().uuid(),
  title: z.string().min(2).max(160),
  description: z.string().max(4000).optional(),
  category: z.string().optional(),
  ageGradeRange: z.string().optional(),
});

export type DemoRole = "parent" | "learner" | "admin";

export type DemoLesson = {
  id: string;
  title: string;
  lessonType: "rich_text" | "video" | "assignment" | "discussion" | "quiz";
  estimatedMinutes: number;
  bodyMarkdown: string;
  completed?: boolean;
};

export type DemoModule = {
  id: string;
  title: string;
  description: string;
  lessons: DemoLesson[];
};

export type DemoCourse = {
  id: string;
  title: string;
  description: string;
  category: string;
  status: "draft" | "published";
  progressPercent: number;
  nextLessonId?: string;
  modules: DemoModule[];
};

export type DemoTodo = {
  id: string;
  title: string;
  courseTitle: string;
  dueLabel: string;
  status: "due" | "missing" | "submitted";
  href: string;
};

export type DemoPost = {
  id: string;
  author: string;
  body: string;
  when: string;
};

export const kingdomTheme = {
  displayName: "Kingdom Preparatory",
  shortName: "KP",
  primaryColor: "#1B3A2E",
  secondaryColor: "#C9A227",
  accentColor: "#C7F000",
  academicYear: "2026–2027",
  ageGradeRange: "Ages 11–14",
};

export const demoLearner = {
  id: "learner-tamika",
  displayName: "Tamika Hale",
  role: "learner" as const,
};

export const demoParent = {
  id: "parent-ada",
  displayName: "Ada Okonkwo",
  role: "parent" as const,
};

export const demoCourses: DemoCourse[] = [
  {
    id: "course-kingdom-business",
    title: "Kingdom Business",
    description:
      "Entrepreneurship, stewardship, and ethical trade through a faith-informed lens.",
    category: "Business",
    status: "published",
    progressPercent: 25,
    nextLessonId: "lesson-trade",
    modules: [
      {
        id: "mod-stewardship",
        title: "Foundations of Stewardship",
        description: "What does it mean to create value while serving others?",
        lessons: [
          {
            id: "lesson-stewardship",
            title: "What Is Stewardship?",
            lessonType: "rich_text",
            estimatedMinutes: 20,
            completed: true,
            bodyMarkdown:
              "Stewardship means caring for resources that are not ours alone — time, talent, and treasure — for the good of our community.\n\nReflect: Where do you already practice stewardship at home?",
          },
          {
            id: "lesson-trade",
            title: "Trade Along the Swahili Coast",
            lessonType: "video",
            estimatedMinutes: 28,
            bodyMarkdown:
              "Watch the approved video, then note three goods that moved across the Indian Ocean trade network.\n\nExternal source: Open Education Channel (approved).",
          },
          {
            id: "lesson-interview",
            title: "Needs Interview Project",
            lessonType: "assignment",
            estimatedMinutes: 40,
            bodyMarkdown:
              "Interview a family member about a problem they wish a small business could solve. Submit your notes.",
          },
          {
            id: "lesson-discussion",
            title: "Stewardship Check-In",
            lessonType: "discussion",
            estimatedMinutes: 15,
            bodyMarkdown:
              "Share one way your venture could serve your neighborhood. Respond kindly to a classmate.",
          },
        ],
      },
      {
        id: "mod-venture",
        title: "Your First Micro-Venture",
        description: "Plan and pitch a small classroom business.",
        lessons: [
          {
            id: "lesson-plan",
            title: "One-Page Venture Plan",
            lessonType: "rich_text",
            estimatedMinutes: 35,
            bodyMarkdown:
              "Draft a one-page plan: customer, problem, offer, and first step this week.",
          },
          {
            id: "lesson-pitch",
            title: "Pitch Practice",
            lessonType: "assignment",
            estimatedMinutes: 30,
            bodyMarkdown: "Record or write a 60-second pitch for your micro-venture.",
          },
        ],
      },
    ],
  },
  {
    id: "course-home-econ",
    title: "Home Economics",
    description: "Cooking, budgeting, hospitality, and care of space.",
    category: "Life Skills",
    status: "published",
    progressPercent: 10,
    nextLessonId: "lesson-meals",
    modules: [
      {
        id: "mod-meals",
        title: "Meals That Nourish",
        description: "Plan and prepare simple meals.",
        lessons: [
          {
            id: "lesson-meals",
            title: "Weekly Meal Sketch",
            lessonType: "rich_text",
            estimatedMinutes: 25,
            bodyMarkdown: "Sketch five dinners that use overlapping ingredients.",
          },
        ],
      },
    ],
  },
  {
    id: "course-env-health",
    title: "Home Environmental Health",
    description: "Air, water, cleaning chemistry, and stewardship of creation.",
    category: "Science",
    status: "published",
    progressPercent: 0,
    modules: [
      {
        id: "mod-air",
        title: "Indoor Air",
        description: "Identify risks and simple improvements.",
        lessons: [
          {
            id: "lesson-air",
            title: "Air Walk",
            lessonType: "rich_text",
            estimatedMinutes: 20,
            bodyMarkdown: "Walk your home and note three ventilation opportunities.",
          },
        ],
      },
    ],
  },
  {
    id: "course-life-christ",
    title: "Life With Christ",
    description: "Scripture, prayer, service, and community rhythms.",
    category: "Faith",
    status: "published",
    progressPercent: 40,
    modules: [
      {
        id: "mod-rhythms",
        title: "Daily Rhythms",
        description: "Build a sustainable devotion habit.",
        lessons: [
          {
            id: "lesson-devotion",
            title: "Morning Devotion Practice",
            lessonType: "rich_text",
            estimatedMinutes: 15,
            completed: true,
            bodyMarkdown: "Read a short passage and write one sentence of gratitude.",
          },
        ],
      },
    ],
  },
];

export const demoTodos: DemoTodo[] = [
  {
    id: "todo-1",
    title: "Needs Interview Notes",
    courseTitle: "Kingdom Business",
    dueLabel: "Due Fri",
    status: "due",
    href: "/learn/courses/course-kingdom-business/lessons/lesson-interview",
  },
  {
    id: "todo-2",
    title: "Trade Along the Swahili Coast",
    courseTitle: "Kingdom Business",
    dueLabel: "Up next",
    status: "due",
    href: "/learn/courses/course-kingdom-business/lessons/lesson-trade",
  },
  {
    id: "todo-3",
    title: "Weekly Meal Sketch",
    courseTitle: "Home Economics",
    dueLabel: "Next week",
    status: "missing",
    href: "/learn/courses/course-home-econ/lessons/lesson-meals",
  },
];

export const demoPosts: DemoPost[] = [
  {
    id: "post-1",
    author: "Ada Okonkwo",
    body: "Welcome, learners! Introduce yourself with one gift you bring to our village.",
    when: "Mon",
  },
  {
    id: "post-2",
    author: "Noah Okonkwo",
    body: "I bring curiosity and baking skills!",
    when: "Mon",
  },
];

export const demoAnnouncements = [
  {
    id: "ann-1",
    title: "Welcome to Kingdom Business",
    body: "This week we begin with stewardship. Complete Lesson 1 before Friday.",
  },
];

export function findCourse(courseId: string) {
  return demoCourses.find((c) => c.id === courseId);
}

export function findLesson(courseId: string, lessonId: string) {
  const course = findCourse(courseId);
  if (!course) return null;
  for (const mod of course.modules) {
    const lesson = mod.lessons.find((l) => l.id === lessonId);
    if (lesson) return { course, module: mod, lesson };
  }
  return null;
}

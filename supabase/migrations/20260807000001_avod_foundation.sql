-- AVOD Phase 0 foundation schema
-- Multi-tenant LMS: organizations → classrooms → courses → modules → lessons
-- Aligns with SRS §8 Data Requirements

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type public.app_role as enum (
  'avod_admin',
  'org_owner',
  'parent_instructor',
  'learner',
  'moderator',
  'support_agent'
);

create type public.membership_status as enum (
  'invited',
  'active',
  'suspended',
  'removed',
  'expired'
);

create type public.course_status as enum (
  'draft',
  'published',
  'paused',
  'archived',
  'deleted'
);

create type public.content_status as enum (
  'draft',
  'scheduled',
  'published',
  'hidden',
  'archived'
);

create type public.lesson_type as enum (
  'rich_text',
  'video',
  'article',
  'file',
  'assignment',
  'quiz',
  'discussion',
  'mixed'
);

create type public.ai_job_status as enum (
  'queued',
  'running',
  'review_ready',
  'failed',
  'canceled',
  'expired'
);

create type public.resource_candidate_status as enum (
  'suggested',
  'approved',
  'rejected',
  'saved',
  'expired',
  'broken'
);

create type public.assignment_status as enum (
  'draft',
  'scheduled',
  'open',
  'closed',
  'archived'
);

create type public.submission_status as enum (
  'draft',
  'submitted',
  'returned',
  'resubmitted',
  'graded',
  'excused'
);

create type public.community_content_status as enum (
  'visible',
  'limited',
  'hidden',
  'removed',
  'restored'
);

create type public.theme_status as enum (
  'draft',
  'published'
);

create type public.notification_channel as enum (
  'in_app',
  'email',
  'push'
);

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create or replace function public.is_avod_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.is_platform_admin = true
  );
$$;

create or replace function public.has_org_role(org uuid, roles public.app_role[])
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.organization_memberships m
    where m.organization_id = org
      and m.user_id = auth.uid()
      and m.status = 'active'
      and m.role = any (roles)
  ) or public.is_avod_admin();
$$;

create or replace function public.is_org_member(org uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.organization_memberships m
    where m.organization_id = org
      and m.user_id = auth.uid()
      and m.status = 'active'
  ) or public.is_avod_admin();
$$;

create or replace function public.has_classroom_role(cls uuid, roles public.app_role[])
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.classroom_memberships cm
    where cm.classroom_id = cls
      and cm.user_id = auth.uid()
      and cm.status = 'active'
      and cm.role = any (roles)
  ) or public.is_avod_admin();
$$;

create or replace function public.is_classroom_member(cls uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.classroom_memberships cm
    where cm.classroom_id = cls
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ) or public.is_avod_admin();
$$;

-- ---------------------------------------------------------------------------
-- Core identity & tenancy
-- ---------------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  display_name text not null,
  avatar_url text,
  role_hint public.app_role not null default 'parent_instructor',
  is_platform_admin boolean not null default false,
  is_minor boolean not null default false,
  guardian_user_id uuid references public.profiles (id),
  timezone text not null default 'America/New_York',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  status text not null default 'active' check (status in ('active', 'suspended', 'archived')),
  plan_code text not null default 'starter',
  owner_user_id uuid references public.profiles (id),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id)
);

create table public.organization_memberships (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role public.app_role not null,
  status public.membership_status not null default 'invited',
  invited_by uuid references public.profiles (id),
  invited_at timestamptz,
  accepted_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (organization_id, user_id, role)
);

create table public.classrooms (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  name text not null,
  short_name text,
  academic_year text,
  age_grade_range text,
  status text not null default 'active' check (status in ('active', 'archived')),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id)
);

create table public.classroom_memberships (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role public.app_role not null,
  status public.membership_status not null default 'invited',
  community_enabled boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (classroom_id, user_id)
);

create table public.classroom_themes (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  status public.theme_status not null default 'draft',
  display_name text not null,
  short_name text,
  logo_url text,
  banner_url text,
  primary_color text not null default '#1B3A2E',
  secondary_color text not null default '#C9A227',
  accent_color text not null default '#C7F000',
  light_dark_preference text not null default 'light' check (light_dark_preference in ('light', 'dark', 'system')),
  font_choice text not null default 'sora',
  contrast_ok boolean not null default true,
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id),
  unique (classroom_id, status)
);

create table public.curriculum_preferences (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete cascade,
  age_range text,
  grade_range text,
  language text not null default 'en',
  values_worldview text,
  pedagogy_notes text,
  source_allowlist text[] not null default '{}',
  source_blocklist text[] not null default '{}',
  safe_search_level text not null default 'strict',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Curriculum
-- ---------------------------------------------------------------------------
create table public.courses (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  title text not null,
  description text,
  status public.course_status not null default 'draft',
  instructor_id uuid references public.profiles (id),
  image_url text,
  category text,
  age_grade_range text,
  prerequisites text,
  learning_outcomes text[] not null default '{}',
  schedule_notes text,
  visibility text not null default 'classroom' check (visibility in ('classroom', 'private')),
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id),
  deleted_at timestamptz
);

create table public.course_enrollments (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  status public.membership_status not null default 'active',
  enrolled_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (course_id, learner_id)
);

create table public.modules (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  title text not null,
  description text,
  objectives text[] not null default '{}',
  estimated_minutes integer,
  sort_order integer not null default 0,
  status public.content_status not null default 'draft',
  cover_image_url text,
  completion_rule text not null default 'all_required',
  available_at timestamptz,
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id)
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  module_id uuid not null references public.modules (id) on delete cascade,
  title text not null,
  lesson_type public.lesson_type not null default 'rich_text',
  status public.content_status not null default 'draft',
  sort_order integer not null default 0,
  is_required boolean not null default true,
  estimated_minutes integer,
  body_markdown text,
  completion_rule text not null default 'mark_complete',
  available_at timestamptz,
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id),
  updated_by uuid references public.profiles (id)
);

create table public.content_blocks (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  lesson_id uuid not null references public.lessons (id) on delete cascade,
  block_type text not null,
  sort_order integer not null default 0,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.resources (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid references public.courses (id) on delete set null,
  module_id uuid references public.modules (id) on delete set null,
  lesson_id uuid references public.lessons (id) on delete set null,
  title text not null,
  resource_type text not null,
  canonical_url text not null,
  provider text,
  external_id text,
  source_name text,
  author_publisher text,
  summary text,
  thumbnail_url text,
  duration_seconds integer,
  license text,
  captions_available boolean,
  approval_status public.resource_candidate_status not null default 'approved',
  approved_by uuid references public.profiles (id),
  approved_at timestamptz,
  last_checked_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.ai_jobs (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete set null,
  course_id uuid references public.courses (id) on delete set null,
  requested_by uuid not null references public.profiles (id),
  job_type text not null check (job_type in ('curriculum', 'resource_discovery', 'revision')),
  status public.ai_job_status not null default 'queued',
  prompt_template_version text,
  provider text,
  model text,
  input_summary jsonb not null default '{}'::jsonb,
  error_code text,
  error_message text,
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.ai_artifacts (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  ai_job_id uuid not null references public.ai_jobs (id) on delete cascade,
  target_type text not null,
  target_id uuid,
  schema_version text not null default '1.0',
  payload jsonb not null,
  safety_notes text[] not null default '{}',
  parent_disposition text check (parent_disposition in ('pending', 'approved', 'rejected', 'edited')),
  disposition_by uuid references public.profiles (id),
  disposition_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.resource_candidates (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete set null,
  ai_job_id uuid references public.ai_jobs (id) on delete set null,
  course_id uuid references public.courses (id) on delete set null,
  module_id uuid references public.modules (id) on delete set null,
  title text not null,
  canonical_url text not null,
  provider text,
  external_id text,
  resource_type text not null,
  source_name text,
  summary text,
  thumbnail_url text,
  duration_seconds integer,
  license text,
  recommendation_reason text,
  recommendation_score numeric(5,2),
  status public.resource_candidate_status not null default 'suggested',
  reviewed_by uuid references public.profiles (id),
  reviewed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Assessments & progress
-- ---------------------------------------------------------------------------
create table public.assignments (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  module_id uuid references public.modules (id) on delete set null,
  lesson_id uuid references public.lessons (id) on delete set null,
  title text not null,
  instructions text,
  status public.assignment_status not null default 'draft',
  due_at timestamptz,
  points numeric(8,2) not null default 100,
  submission_types text[] not null default array['text'],
  late_policy text,
  allow_resubmission boolean not null default true,
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  created_by uuid references public.profiles (id)
);

create table public.submissions (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  assignment_id uuid not null references public.assignments (id) on delete cascade,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  version integer not null default 1,
  status public.submission_status not null default 'draft',
  body_text text,
  link_url text,
  file_asset_id uuid,
  idempotency_key text,
  submitted_at timestamptz,
  returned_at timestamptz,
  graded_at timestamptz,
  score numeric(8,2),
  feedback text,
  grader_id uuid references public.profiles (id),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (assignment_id, learner_id, version),
  unique (assignment_id, learner_id, idempotency_key)
);

create table public.quizzes (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  lesson_id uuid references public.lessons (id) on delete set null,
  title text not null,
  status public.content_status not null default 'draft',
  points numeric(8,2) not null default 100,
  attempts_allowed integer not null default 1,
  time_limit_seconds integer,
  passing_score numeric(5,2),
  randomize boolean not null default false,
  feedback_visibility text not null default 'after_submit',
  available_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  quiz_id uuid not null references public.quizzes (id) on delete cascade,
  question_type text not null check (question_type in ('multiple_choice', 'multiple_select', 'true_false', 'short_answer', 'essay')),
  prompt text not null,
  options jsonb not null default '[]'::jsonb,
  correct_answer jsonb,
  points numeric(8,2) not null default 1,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  quiz_id uuid not null references public.quizzes (id) on delete cascade,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  attempt_number integer not null default 1,
  status text not null default 'in_progress' check (status in ('in_progress', 'submitted', 'graded')),
  responses jsonb not null default '{}'::jsonb,
  score numeric(8,2),
  started_at timestamptz not null default timezone('utc', now()),
  submitted_at timestamptz,
  graded_at timestamptz,
  idempotency_key text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (quiz_id, learner_id, attempt_number),
  unique (quiz_id, learner_id, idempotency_key)
);

create table public.gradebook_entries (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  source_type text not null,
  source_id uuid not null,
  score numeric(8,2),
  points_possible numeric(8,2) not null,
  feedback text,
  grader_id uuid references public.profiles (id),
  override_reason text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (source_type, source_id, learner_id)
);

create table public.progress_events (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  module_id uuid references public.modules (id) on delete set null,
  lesson_id uuid references public.lessons (id) on delete set null,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  event_type text not null,
  event_key text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  unique (learner_id, lesson_id, event_type, event_key)
);

create table public.progress_snapshots (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid not null references public.courses (id) on delete cascade,
  module_id uuid references public.modules (id) on delete cascade,
  lesson_id uuid references public.lessons (id) on delete cascade,
  learner_id uuid not null references public.profiles (id) on delete cascade,
  percent_complete numeric(5,2) not null default 0,
  status text not null default 'not_started' check (status in ('not_started', 'in_progress', 'completed')),
  completed_at timestamptz,
  updated_at timestamptz not null default timezone('utc', now())
);

create unique index progress_snapshots_lesson_uidx
  on public.progress_snapshots (learner_id, lesson_id)
  where lesson_id is not null;

create unique index progress_snapshots_module_uidx
  on public.progress_snapshots (learner_id, module_id)
  where module_id is not null and lesson_id is null;

create unique index progress_snapshots_course_uidx
  on public.progress_snapshots (learner_id, course_id)
  where module_id is null and lesson_id is null;

-- ---------------------------------------------------------------------------
-- Calendar, community, notifications, files, audit
-- ---------------------------------------------------------------------------
create table public.calendar_events (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete cascade,
  course_id uuid references public.courses (id) on delete set null,
  assignment_id uuid references public.assignments (id) on delete set null,
  title text not null,
  description text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  all_day boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete cascade,
  course_id uuid references public.courses (id) on delete set null,
  title text not null,
  body text not null,
  published_at timestamptz,
  created_by uuid references public.profiles (id),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.communities (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  course_id uuid references public.courses (id) on delete set null,
  name text not null,
  learner_posting_enabled boolean not null default true,
  learner_commenting_enabled boolean not null default true,
  reactions_enabled boolean not null default true,
  attachments_enabled boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.community_posts (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  community_id uuid not null references public.communities (id) on delete cascade,
  author_id uuid not null references public.profiles (id),
  body text not null,
  status public.community_content_status not null default 'visible',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.community_comments (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  post_id uuid not null references public.community_posts (id) on delete cascade,
  author_id uuid not null references public.profiles (id),
  body text not null,
  status public.community_content_status not null default 'visible',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.community_reports (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  reporter_id uuid not null references public.profiles (id),
  target_type text not null check (target_type in ('post', 'comment')),
  target_id uuid not null,
  reason text not null,
  note text,
  status text not null default 'open' check (status in ('open', 'in_review', 'resolved', 'dismissed')),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.moderation_actions (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid not null references public.classrooms (id) on delete cascade,
  report_id uuid references public.community_reports (id) on delete set null,
  actor_id uuid not null references public.profiles (id),
  target_type text not null,
  target_id uuid not null,
  action text not null,
  reason text not null,
  created_at timestamptz not null default timezone('utc', now())
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references public.organizations (id) on delete cascade,
  recipient_id uuid not null references public.profiles (id) on delete cascade,
  channel public.notification_channel not null default 'in_app',
  event_type text not null,
  title text not null,
  body text not null,
  deep_link text,
  read_at timestamptz,
  delivered_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  platform text not null check (platform in ('ios', 'android', 'web')),
  token text not null,
  status text not null default 'active' check (status in ('active', 'disabled', 'invalid')),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (user_id, token)
);

create table public.file_assets (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete set null,
  owner_id uuid not null references public.profiles (id),
  purpose text not null,
  storage_bucket text not null,
  storage_key text not null,
  mime_type text,
  byte_size bigint,
  scan_status text not null default 'pending' check (scan_status in ('pending', 'clean', 'rejected', 'error')),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid,
  classroom_id uuid,
  actor_id uuid,
  action text not null,
  target_type text,
  target_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);

create table public.invitations (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  classroom_id uuid references public.classrooms (id) on delete cascade,
  email text not null,
  role public.app_role not null,
  token_hash text not null unique,
  expires_at timestamptz not null,
  accepted_at timestamptz,
  invited_by uuid references public.profiles (id),
  created_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------
create index idx_org_memberships_user on public.organization_memberships (user_id);
create index idx_org_memberships_org on public.organization_memberships (organization_id, status);
create index idx_classroom_memberships_user on public.classroom_memberships (user_id);
create index idx_classroom_memberships_cls on public.classroom_memberships (classroom_id, status);
create index idx_courses_classroom on public.courses (classroom_id, status);
create index idx_modules_course on public.modules (course_id, sort_order);
create index idx_lessons_module on public.lessons (module_id, sort_order);
create index idx_enrollments_learner on public.course_enrollments (learner_id, status);
create index idx_progress_events_learner on public.progress_events (learner_id, created_at desc);
create index idx_progress_snapshots_learner on public.progress_snapshots (learner_id, course_id);
create index idx_assignments_due on public.assignments (classroom_id, due_at);
create index idx_notifications_recipient on public.notifications (recipient_id, created_at desc);
create index idx_community_posts_community on public.community_posts (community_id, created_at desc);
create index idx_audit_logs_org on public.audit_logs (organization_id, created_at desc);
create index idx_ai_jobs_org_status on public.ai_jobs (organization_id, status);

-- ---------------------------------------------------------------------------
-- Updated-at triggers
-- ---------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles','organizations','organization_memberships','classrooms','classroom_memberships',
    'classroom_themes','curriculum_preferences','courses','course_enrollments','modules','lessons',
    'content_blocks','resources','ai_jobs','ai_artifacts','resource_candidates','assignments',
    'submissions','quizzes','quiz_questions','quiz_attempts','gradebook_entries','calendar_events',
    'announcements','communities','community_posts','community_comments','community_reports',
    'device_tokens','file_assets'
  ]
  loop
    execute format(
      'create trigger set_%s_updated_at before update on public.%I for each row execute function public.set_updated_at()',
      t, t
    );
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Profile bootstrap on signup
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name, role_hint, is_minor)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)),
    coalesce((new.raw_user_meta_data->>'role_hint')::public.app_role, 'parent_instructor'),
    coalesce((new.raw_user_meta_data->>'is_minor')::boolean, false)
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

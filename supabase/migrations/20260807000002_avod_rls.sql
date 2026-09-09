-- AVOD row-level security policies (AUTHZ-001..005, SEC-002)

alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_memberships enable row level security;
alter table public.classrooms enable row level security;
alter table public.classroom_memberships enable row level security;
alter table public.classroom_themes enable row level security;
alter table public.curriculum_preferences enable row level security;
alter table public.courses enable row level security;
alter table public.course_enrollments enable row level security;
alter table public.modules enable row level security;
alter table public.lessons enable row level security;
alter table public.content_blocks enable row level security;
alter table public.resources enable row level security;
alter table public.ai_jobs enable row level security;
alter table public.ai_artifacts enable row level security;
alter table public.resource_candidates enable row level security;
alter table public.assignments enable row level security;
alter table public.submissions enable row level security;
alter table public.quizzes enable row level security;
alter table public.quiz_questions enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.gradebook_entries enable row level security;
alter table public.progress_events enable row level security;
alter table public.progress_snapshots enable row level security;
alter table public.calendar_events enable row level security;
alter table public.announcements enable row level security;
alter table public.communities enable row level security;
alter table public.community_posts enable row level security;
alter table public.community_comments enable row level security;
alter table public.community_reports enable row level security;
alter table public.moderation_actions enable row level security;
alter table public.notifications enable row level security;
alter table public.device_tokens enable row level security;
alter table public.file_assets enable row level security;
alter table public.audit_logs enable row level security;
alter table public.invitations enable row level security;

-- Profiles
create policy profiles_select_self_or_org on public.profiles
  for select using (
    id = auth.uid()
    or public.is_avod_admin()
    or exists (
      select 1 from public.organization_memberships mine
      join public.organization_memberships theirs
        on mine.organization_id = theirs.organization_id
      where mine.user_id = auth.uid()
        and mine.status = 'active'
        and theirs.user_id = profiles.id
        and theirs.status = 'active'
    )
  );

create policy profiles_update_self on public.profiles
  for update using (id = auth.uid() or public.is_avod_admin());

-- Organizations
create policy orgs_select_member on public.organizations
  for select using (public.is_org_member(id));

create policy orgs_insert_admin on public.organizations
  for insert with check (public.is_avod_admin() or auth.uid() is not null);

create policy orgs_update_owner on public.organizations
  for update using (
    public.has_org_role(id, array['org_owner'::public.app_role])
  );

-- Organization memberships
create policy org_memberships_select on public.organization_memberships
  for select using (public.is_org_member(organization_id) or user_id = auth.uid());

create policy org_memberships_manage on public.organization_memberships
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Classrooms
create policy classrooms_select on public.classrooms
  for select using (public.is_org_member(organization_id));

create policy classrooms_manage on public.classrooms
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Classroom memberships
create policy classroom_memberships_select on public.classroom_memberships
  for select using (public.is_classroom_member(classroom_id) or user_id = auth.uid());

create policy classroom_memberships_manage on public.classroom_memberships
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Themes
create policy themes_select on public.classroom_themes
  for select using (public.is_classroom_member(classroom_id));

create policy themes_manage on public.classroom_themes
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Curriculum preferences
create policy curriculum_prefs_select on public.curriculum_preferences
  for select using (public.is_org_member(organization_id));

create policy curriculum_prefs_manage on public.curriculum_preferences
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Courses: adults see all statuses; learners see published only
create policy courses_select on public.courses
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
    or (
      public.is_classroom_member(classroom_id)
      and status = 'published'
      and deleted_at is null
    )
  );

create policy courses_manage on public.courses
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Enrollments
create policy enrollments_select on public.course_enrollments
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy enrollments_manage on public.course_enrollments
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Modules / lessons / blocks / resources
create policy modules_select on public.modules
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or (public.is_classroom_member(classroom_id) and status = 'published')
  );

create policy modules_manage on public.modules
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy lessons_select on public.lessons
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or (public.is_classroom_member(classroom_id) and status = 'published')
  );

create policy lessons_manage on public.lessons
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy content_blocks_select on public.content_blocks
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or public.is_classroom_member(classroom_id)
  );

create policy content_blocks_manage on public.content_blocks
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy resources_select on public.resources
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or (public.is_classroom_member(classroom_id) and approval_status = 'approved')
  );

create policy resources_manage on public.resources
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- AI artifacts remain invisible to learners (AI-004)
create policy ai_jobs_adults on public.ai_jobs
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy ai_artifacts_adults on public.ai_artifacts
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy resource_candidates_adults on public.resource_candidates
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Assignments & submissions
create policy assignments_select on public.assignments
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or (public.is_classroom_member(classroom_id) and status in ('open', 'closed'))
  );

create policy assignments_manage on public.assignments
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy submissions_select on public.submissions
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy submissions_insert_own on public.submissions
  for insert with check (learner_id = auth.uid());

create policy submissions_update_own_or_grader on public.submissions
  for update using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Quizzes
create policy quizzes_select on public.quizzes
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
    or (public.is_classroom_member(classroom_id) and status = 'published')
  );

create policy quizzes_manage on public.quizzes
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy quiz_questions_select on public.quiz_questions
  for select using (
    exists (
      select 1 from public.quizzes q
      where q.id = quiz_questions.quiz_id
        and (
          public.has_org_role(q.organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
          or (public.is_classroom_member(q.classroom_id) and q.status = 'published')
        )
    )
  );

create policy quiz_questions_manage on public.quiz_questions
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy quiz_attempts_select on public.quiz_attempts
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy quiz_attempts_insert_own on public.quiz_attempts
  for insert with check (learner_id = auth.uid());

create policy quiz_attempts_update_own_or_grader on public.quiz_attempts
  for update using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Gradebook: learners see only their own (GRD-003)
create policy gradebook_select on public.gradebook_entries
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy gradebook_manage on public.gradebook_entries
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Progress
create policy progress_events_select on public.progress_events
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy progress_events_insert_own on public.progress_events
  for insert with check (learner_id = auth.uid());

create policy progress_snapshots_select on public.progress_snapshots
  for select using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy progress_snapshots_upsert on public.progress_snapshots
  for all using (
    learner_id = auth.uid()
    or public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Calendar & announcements
create policy calendar_select on public.calendar_events
  for select using (
    classroom_id is null and public.is_org_member(organization_id)
    or public.is_classroom_member(classroom_id)
  );

create policy calendar_manage on public.calendar_events
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy announcements_select on public.announcements
  for select using (
    classroom_id is null and public.is_org_member(organization_id)
    or public.is_classroom_member(classroom_id)
  );

create policy announcements_manage on public.announcements
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

-- Community (private classroom only)
create policy communities_select on public.communities
  for select using (public.is_classroom_member(classroom_id));

create policy communities_manage on public.communities
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

create policy community_posts_select on public.community_posts
  for select using (
    public.is_classroom_member(classroom_id)
    and status in ('visible', 'limited', 'restored')
  );

create policy community_posts_insert on public.community_posts
  for insert with check (
    author_id = auth.uid() and public.is_classroom_member(classroom_id)
  );

create policy community_posts_moderate on public.community_posts
  for update using (
    author_id = auth.uid()
    or public.has_classroom_role(classroom_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

create policy community_comments_select on public.community_comments
  for select using (
    public.is_classroom_member(classroom_id)
    and status in ('visible', 'limited', 'restored')
  );

create policy community_comments_insert on public.community_comments
  for insert with check (
    author_id = auth.uid() and public.is_classroom_member(classroom_id)
  );

create policy community_comments_moderate on public.community_comments
  for update using (
    author_id = auth.uid()
    or public.has_classroom_role(classroom_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

create policy community_reports_insert on public.community_reports
  for insert with check (
    reporter_id = auth.uid() and public.is_classroom_member(classroom_id)
  );

create policy community_reports_moderate on public.community_reports
  for all using (
    public.has_classroom_role(classroom_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

create policy moderation_actions_select on public.moderation_actions
  for select using (
    public.has_classroom_role(classroom_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

create policy moderation_actions_insert on public.moderation_actions
  for insert with check (
    actor_id = auth.uid()
    and public.has_classroom_role(classroom_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role, 'moderator'::public.app_role])
  );

-- Notifications & devices
create policy notifications_own on public.notifications
  for all using (recipient_id = auth.uid());

create policy device_tokens_own on public.device_tokens
  for all using (user_id = auth.uid());

-- Files
create policy file_assets_select on public.file_assets
  for select using (
    owner_id = auth.uid()
    or public.is_org_member(organization_id)
  );

create policy file_assets_insert on public.file_assets
  for insert with check (owner_id = auth.uid() and public.is_org_member(organization_id));

-- Audit logs: org adults + platform admin
create policy audit_logs_select on public.audit_logs
  for select using (
    public.is_avod_admin()
    or (organization_id is not null and public.has_org_role(organization_id, array['org_owner'::public.app_role]))
  );

create policy audit_logs_insert on public.audit_logs
  for insert with check (auth.uid() is not null);

-- Invitations
create policy invitations_select on public.invitations
  for select using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

create policy invitations_manage on public.invitations
  for all using (
    public.has_org_role(organization_id, array['org_owner'::public.app_role, 'parent_instructor'::public.app_role])
  );

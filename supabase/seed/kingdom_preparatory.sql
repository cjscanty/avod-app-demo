-- Kingdom Preparatory reference seed (non-production only)
-- Synthetic users must be created in auth.users first, or use demo mode in the app.
-- This seed uses fixed UUIDs for deterministic local demos.

create or replace function public.seed_kingdom_preparatory()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin uuid := 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
  v_owner uuid := 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
  v_parent uuid := 'cccccccc-cccc-cccc-cccc-cccccccccccc';
  v_moderator uuid := 'dddddddd-dddd-dddd-dddd-dddddddddddd';
  v_learner1 uuid := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
  v_learner2 uuid := 'ffffffff-ffff-ffff-ffff-ffffffffffff';
  v_org uuid := '11111111-1111-1111-1111-111111111111';
  v_classroom uuid := '22222222-2222-2222-2222-222222222222';
  v_community uuid := '33333333-3333-3333-3333-333333333333';
  v_course1 uuid := '44444444-4444-4444-4444-444444444401';
  v_course2 uuid := '44444444-4444-4444-4444-444444444402';
  v_course3 uuid := '44444444-4444-4444-4444-444444444403';
  v_course4 uuid := '44444444-4444-4444-4444-444444444404';
  v_mod1 uuid := '55555555-5555-5555-5555-555555555501';
  v_mod2 uuid := '55555555-5555-5555-5555-555555555502';
  v_lesson1 uuid := '66666666-6666-6666-6666-666666666601';
  v_lesson2 uuid := '66666666-6666-6666-6666-666666666602';
  v_lesson3 uuid := '66666666-6666-6666-6666-666666666603';
  v_lesson4 uuid := '66666666-6666-6666-6666-666666666604';
  v_assign uuid := '77777777-7777-7777-7777-777777777777';
  v_quiz uuid := '88888888-8888-8888-8888-888888888888';
  v_ai_job uuid := '99999999-9999-9999-9999-999999999999';
  v_post uuid := 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
  v_comment uuid := 'bbbbbbbb-cccc-dddd-eeee-ffffffffffff';
begin
  -- Profiles (only if corresponding auth users exist — insert with ON CONFLICT)
  insert into public.profiles (id, email, display_name, role_hint, is_platform_admin, is_minor, guardian_user_id)
  values
    (v_admin, 'admin@avod.local', 'AVOD Admin', 'avod_admin', true, false, null),
    (v_owner, 'owner@kingdomprep.local', 'Jordan Hale', 'org_owner', false, false, null),
    (v_parent, 'parent@kingdomprep.local', 'Ada Okonkwo', 'parent_instructor', false, false, null),
    (v_moderator, 'mod@kingdomprep.local', 'Sam Rivera', 'moderator', false, false, null),
    (v_learner1, 'learner1@kingdomprep.local', 'Tamika Hale', 'learner', false, true, v_owner),
    (v_learner2, 'learner2@kingdomprep.local', 'Noah Okonkwo', 'learner', false, true, v_parent)
  on conflict (id) do update set display_name = excluded.display_name;

  insert into public.organizations (id, name, slug, status, plan_code, owner_user_id, created_by)
  values (v_org, 'Kingdom Preparatory', 'kingdom-preparatory', 'active', 'village', v_owner, v_admin)
  on conflict (id) do nothing;

  insert into public.organization_memberships (organization_id, user_id, role, status, accepted_at)
  values
    (v_org, v_owner, 'org_owner', 'active', now()),
    (v_org, v_parent, 'parent_instructor', 'active', now()),
    (v_org, v_moderator, 'moderator', 'active', now()),
    (v_org, v_learner1, 'learner', 'active', now()),
    (v_org, v_learner2, 'learner', 'active', now())
  on conflict do nothing;

  insert into public.classrooms (id, organization_id, name, short_name, academic_year, age_grade_range, status, created_by)
  values (v_classroom, v_org, 'Kingdom Preparatory Homeroom', 'KP', '2026-2027', 'Ages 11–14', 'active', v_owner)
  on conflict (id) do nothing;

  insert into public.classroom_memberships (organization_id, classroom_id, user_id, role, status)
  values
    (v_org, v_classroom, v_owner, 'org_owner', 'active'),
    (v_org, v_classroom, v_parent, 'parent_instructor', 'active'),
    (v_org, v_classroom, v_moderator, 'moderator', 'active'),
    (v_org, v_classroom, v_learner1, 'learner', 'active'),
    (v_org, v_classroom, v_learner2, 'learner', 'active')
  on conflict do nothing;

  insert into public.classroom_themes (
    organization_id, classroom_id, status, display_name, short_name,
    primary_color, secondary_color, accent_color, light_dark_preference, font_choice, contrast_ok, published_at
  ) values (
    v_org, v_classroom, 'published', 'Kingdom Preparatory', 'KP',
    '#1B3A2E', '#C9A227', '#C7F000', 'light', 'sora', true, now()
  ) on conflict do nothing;

  insert into public.curriculum_preferences (
    organization_id, classroom_id, age_range, grade_range, values_worldview, pedagogy_notes, safe_search_level
  ) values (
    v_org, v_classroom, '11-14', '6-8',
    'Christian faith-informed stewardship and community service',
    'Hands-on projects, scripture reflection, and practical skills',
    'strict'
  );

  -- Four reference courses
  insert into public.courses (
    id, organization_id, classroom_id, title, description, status, instructor_id,
    category, age_grade_range, learning_outcomes, published_at, created_by
  ) values
    (v_course1, v_org, v_classroom, 'Kingdom Business',
     'Entrepreneurship, stewardship, and ethical trade through a faith-informed lens.',
     'published', v_parent, 'Business', '11-14',
     array['Explain value creation', 'Budget a small venture', 'Practice ethical negotiation'],
     now(), v_parent),
    (v_course2, v_org, v_classroom, 'Home Economics',
     'Practical home management: cooking, budgeting, hospitality, and care of space.',
     'published', v_parent, 'Life Skills', '11-14',
     array['Plan a weekly meal', 'Track household expenses', 'Host with hospitality'],
     now(), v_parent),
    (v_course3, v_org, v_classroom, 'Home Environmental Health',
     'Healthy homes: air, water, cleaning chemistry, and stewardship of creation.',
     'published', v_parent, 'Science', '11-14',
     array['Identify indoor air risks', 'Choose safer cleaners', 'Map a water cycle at home'],
     now(), v_parent),
    (v_course4, v_org, v_classroom, 'Life With Christ',
     'Discipleship rhythms: scripture, prayer, service, and community life.',
     'published', v_owner, 'Faith', '11-14',
     array['Practice a daily devotion', 'Serve a neighbor', 'Reflect on scripture in writing'],
     now(), v_owner)
  on conflict (id) do nothing;

  insert into public.course_enrollments (organization_id, classroom_id, course_id, learner_id, status)
  values
    (v_org, v_classroom, v_course1, v_learner1, 'active'),
    (v_org, v_classroom, v_course1, v_learner2, 'active'),
    (v_org, v_classroom, v_course2, v_learner1, 'active'),
    (v_org, v_classroom, v_course3, v_learner2, 'active'),
    (v_org, v_classroom, v_course4, v_learner1, 'active'),
    (v_org, v_classroom, v_course4, v_learner2, 'active')
  on conflict do nothing;

  insert into public.modules (
    id, organization_id, classroom_id, course_id, title, description, objectives,
    estimated_minutes, sort_order, status, published_at, created_by
  ) values
    (v_mod1, v_org, v_classroom, v_course1, 'Foundations of Stewardship',
     'What does it mean to create value while serving others?',
     array['Define stewardship', 'Identify customer needs'], 90, 1, 'published', now(), v_parent),
    (v_mod2, v_org, v_classroom, v_course1, 'Your First Micro-Venture',
     'Plan and pitch a small classroom business.',
     array['Write a simple plan', 'Present a pitch'], 120, 2, 'published', now(), v_parent)
  on conflict (id) do nothing;

  insert into public.lessons (
    id, organization_id, classroom_id, course_id, module_id, title, lesson_type,
    status, sort_order, is_required, estimated_minutes, body_markdown, published_at, created_by
  ) values
    (v_lesson1, v_org, v_classroom, v_course1, v_mod1, 'What Is Stewardship?',
     'rich_text', 'published', 1, true, 20,
     E'# Stewardship\n\nStewardship means caring for resources that are not ours alone — time, talent, and treasure — for the good of our community.\n\nReflect: Where do you already practice stewardship at home?',
     now(), v_parent),
    (v_lesson2, v_org, v_classroom, v_course1, v_mod1, 'Trade Along the Swahili Coast',
     'video', 'published', 2, true, 28,
     E'# Trade Along the Swahili Coast\n\nWatch the approved video, then note three goods that moved across the Indian Ocean trade network.',
     now(), v_parent),
    (v_lesson3, v_org, v_classroom, v_course1, v_mod1, 'Needs Interview Project',
     'assignment', 'published', 3, true, 40,
     E'# Needs Interview\n\nInterview a family member about a problem they wish a small business could solve. Submit your notes.',
     now(), v_parent),
    (v_lesson4, v_org, v_classroom, v_course1, v_mod1, 'Stewardship Check-In',
     'discussion', 'published', 4, true, 15,
     E'# Discussion\n\nShare one way your venture could serve your neighborhood. Respond kindly to a classmate.',
     now(), v_parent)
  on conflict (id) do nothing;

  insert into public.resources (
    organization_id, classroom_id, course_id, module_id, lesson_id,
    title, resource_type, canonical_url, provider, external_id, source_name,
    summary, approval_status, approved_by, approved_at
  ) values (
    v_org, v_classroom, v_course1, v_mod1, v_lesson2,
    'Indian Ocean Trade Overview', 'video',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'youtube', 'dQw4w9WgXcQ', 'Open Education Channel',
    'Age-appropriate overview of historic trade routes (placeholder URL for demo).',
    'approved', v_parent, now()
  );

  insert into public.content_blocks (organization_id, classroom_id, lesson_id, block_type, sort_order, payload)
  values
    (v_org, v_classroom, v_lesson1, 'markdown', 1, jsonb_build_object('markdown', 'Read the stewardship introduction and complete the reflection.')),
    (v_org, v_classroom, v_lesson2, 'video', 1, jsonb_build_object('provider', 'youtube', 'externalId', 'dQw4w9WgXcQ', 'title', 'Indian Ocean Trade Overview'));

  insert into public.assignments (
    id, organization_id, classroom_id, course_id, module_id, lesson_id,
    title, instructions, status, due_at, points, submission_types, published_at, created_by
  ) values (
    v_assign, v_org, v_classroom, v_course1, v_mod1, v_lesson3,
    'Needs Interview Notes',
    'Submit a short paragraph summarizing the interview.',
    'open', now() + interval '7 days', 20, array['text'], now(), v_parent
  ) on conflict (id) do nothing;

  insert into public.submissions (
    organization_id, classroom_id, assignment_id, learner_id, version, status,
    body_text, submitted_at, idempotency_key
  ) values (
    v_org, v_classroom, v_assign, v_learner1, 1, 'submitted',
    'My uncle wants a better way to schedule neighborhood rideshare for church events.',
    now(), 'seed-submission-1'
  ) on conflict do nothing;

  insert into public.quizzes (
    id, organization_id, classroom_id, course_id, lesson_id, title, status, points, attempts_allowed, passing_score
  ) values (
    v_quiz, v_org, v_classroom, v_course1, v_lesson1, 'Stewardship Basics', 'published', 10, 2, 70
  ) on conflict (id) do nothing;

  insert into public.quiz_questions (organization_id, quiz_id, question_type, prompt, options, correct_answer, points, sort_order)
  values (
    v_org, v_quiz, 'multiple_choice',
    'Stewardship primarily means:',
    '["Owning everything yourself","Caring for resources for a greater good","Avoiding all risk","Only managing money"]'::jsonb,
    '"Caring for resources for a greater good"'::jsonb,
    5, 1
  );

  insert into public.quiz_attempts (
    organization_id, classroom_id, quiz_id, learner_id, attempt_number, status, responses, score, submitted_at, graded_at, idempotency_key
  ) values (
    v_org, v_classroom, v_quiz, v_learner1, 1, 'graded',
    '{"1":"Caring for resources for a greater good"}'::jsonb,
    5, now(), now(), 'seed-quiz-1'
  ) on conflict do nothing;

  insert into public.gradebook_entries (
    organization_id, classroom_id, course_id, learner_id, source_type, source_id, score, points_possible, grader_id, feedback
  ) values (
    v_org, v_classroom, v_course1, v_learner1, 'quiz_attempt', v_quiz, 5, 10, v_parent, 'Solid start — keep reflecting.'
  ) on conflict do nothing;

  insert into public.progress_events (
    organization_id, classroom_id, course_id, module_id, lesson_id, learner_id, event_type, event_key
  ) values (
    v_org, v_classroom, v_course1, v_mod1, v_lesson1, v_learner1, 'lesson_completed', 'complete'
  ) on conflict do nothing;

  insert into public.progress_snapshots (
    organization_id, classroom_id, course_id, module_id, lesson_id, learner_id, percent_complete, status, completed_at
  ) values (
    v_org, v_classroom, v_course1, v_mod1, v_lesson1, v_learner1, 100, 'completed', now()
  ) on conflict do nothing;

  insert into public.announcements (
    organization_id, classroom_id, course_id, title, body, published_at, created_by
  ) values (
    v_org, v_classroom, v_course1, 'Welcome to Kingdom Business',
    'This week we begin with stewardship. Complete Lesson 1 before Friday.',
    now(), v_parent
  );

  insert into public.communities (id, organization_id, classroom_id, name)
  values (v_community, v_org, v_classroom, 'KP Village Square')
  on conflict (id) do nothing;

  insert into public.community_posts (id, organization_id, classroom_id, community_id, author_id, body, status)
  values (v_post, v_org, v_classroom, v_community, v_parent, 'Welcome, learners! Introduce yourself with one gift you bring to our village.', 'visible')
  on conflict (id) do nothing;

  insert into public.community_comments (id, organization_id, classroom_id, post_id, author_id, body, status)
  values (v_comment, v_org, v_classroom, v_post, v_learner2, 'I bring curiosity and baking skills!', 'visible')
  on conflict (id) do nothing;

  insert into public.community_reports (
    organization_id, classroom_id, reporter_id, target_type, target_id, reason, note, status
  ) values (
    v_org, v_classroom, v_learner1, 'comment', v_comment, 'other', 'Demo report for moderator queue', 'open'
  );

  insert into public.ai_jobs (
    id, organization_id, classroom_id, course_id, requested_by, job_type, status,
    prompt_template_version, provider, model, input_summary, completed_at
  ) values (
    v_ai_job, v_org, v_classroom, v_course1, v_parent, 'curriculum', 'review_ready',
    'curriculum-v1', 'demo', 'demo-model',
    '{"topic":"Kingdom Business","age":"11-14"}'::jsonb, now()
  ) on conflict (id) do nothing;

  insert into public.ai_artifacts (
    organization_id, ai_job_id, target_type, target_id, schema_version, payload, parent_disposition, disposition_by, disposition_at
  ) values (
    v_org, v_ai_job, 'course', v_course1, '1.0',
    '{"title":"Kingdom Business","modules":[{"title":"Foundations of Stewardship"}]}'::jsonb,
    'approved', v_parent, now()
  );

  insert into public.audit_logs (organization_id, classroom_id, actor_id, action, target_type, target_id, metadata)
  values
    (v_org, v_classroom, v_parent, 'course.published', 'course', v_course1, '{"title":"Kingdom Business"}'::jsonb),
    (v_org, v_classroom, v_parent, 'ai.artifact.approved', 'ai_job', v_ai_job, '{}'::jsonb);

  insert into public.calendar_events (organization_id, classroom_id, course_id, assignment_id, title, starts_at, all_day)
  values (v_org, v_classroom, v_course1, v_assign, 'Needs Interview due', now() + interval '7 days', true);
end;
$$;

-- Note: call select public.seed_kingdom_preparatory(); after creating matching auth users.

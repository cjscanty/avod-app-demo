# AVOD — African Village of Discovery

The full single-file build of the multi-tenant homeschool platform — landing page, branded villages, course player with quizzes, progress tracking, community, events, and super admin console. Runs statically; sample data; state persists in-browser via localStorage.

## Live

GitHub Pages serves `index.html` at:

  https://cjscanty.github.io/avod-app-demo/

## The app

- **Landing page** — hero, how-it-works grid, and a working interest form that feeds the Super Admin provisioning queue
- **Two branded villages** — Kingdom Preparatory (gold crown, kingdomprep.org) and Ubuntu Leadership Academy (terracotta globe) with full tenant isolation
- **Village Square** — live stat dashboard and latest chronicle entries
- **My Journey** — completion rings, up-next lessons, mastery by village label, Showcase Gallery, printable weekly summary card
- **Course Player** — module/lesson rail, video and reading stages, project step checklists, graded quizzes that record to the journey
- **Course Studio** — catalog, publish/unpublish, create drafts, add modules
- **Learners, Gradebook (inline grading), Village Voice (post + moderation), Events, Branding editor (live), Chronicle audit log**
- **Super Admin** — network-wide meters, village directory, moderation queue, provisioning feed

## Deep links

- `?village=cls_ula` — open Ubuntu Leadership Academy directly
- `?village=cls_kp&journey=tamika` — Tamika's parent journey page
- `?play=africiv` — land in the African Civilizations course player

## Data

All mutations (published courses, grades, posts, branding, extra lesson completions) persist in localStorage. Use **Reset demo data** (sidebar footer) to restore the seed state.

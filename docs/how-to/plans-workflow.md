---
title: 'How to work the plans workflow'
description: Move a plan through backlog → in-progress → done and commit the transitions.
category: how-to
---

# How to work the plans workflow

Work is driven by planning documents in [`plans/`](../../plans), following the
[ose-primer plans convention](https://github.com/wahidyankf/ose-primer). A plan's
**folder is its state** — there is no hidden status field.

| Folder         | Meaning              | Filename prefix                |
| -------------- | -------------------- | ------------------------------ |
| `backlog/`     | Planned, not started | creation date `YYYY-MM-DD-…`   |
| `in-progress/` | Being executed       | none (date prefix dropped)     |
| `done/`        | Completed            | completion date `YYYY-MM-DD-…` |

## Start a plan

```bash
git mv plans/backlog/2026-06-01-02-transactions.md \
       plans/in-progress/02-transactions.md
git commit -m "docs: move Plan 02 to in-progress"
```

## Finish a plan

Only when its **acceptance criteria pass** (`flutter analyze` clean, `flutter
test` green, `dart format` clean):

```bash
git mv plans/in-progress/02-transactions.md \
       plans/done/2026-06-08-02-transactions.md
git commit -m "docs: mark Plan 02 (transactions) done"
```

## Conventions

- One plan per file; each lists Objective, Scope, Tasks, and **Acceptance criteria**.
- Execute in order; a plan declares its `depends_on` in frontmatter.
- Keep the index in [`plans/README.md`](../../plans/README.md) in sync when you
  add or move a plan.
- Commit the move as its own small, conventional commit.

## Current plans

Both live plans are in [`plans/in-progress/`](../../plans/in-progress): the
master roadmap (`00-overview.md`) and the Week 1 skeleton bootstrap
(`01-week-1-skeleton.md`). See [`plans/README.md`](../../plans/README.md).

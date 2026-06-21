---
title: 'Flutter reference notes'
description: Vendored general-purpose Flutter notes — the upstream conventions this project follows.
category: reference
subcategory: flutter
---

# Flutter reference notes

These are **general Flutter knowledge notes**, copied from the owner's personal
notes vault (`software-engineering/mobile/flutter/`) so the repo is
self-contained. They are **not sakinah-specific** — they're the upstream
conventions the project's own architecture and decisions are derived from.

The only adaptation on copy was **rewriting Obsidian wikilinks** to relative
links (and the Sakinah Wallet reference now points at
[`plans/in-progress/00-overview.md`](../../../plans/in-progress/00-overview.md)).
The vault keeps the originals; this copy is **maintained manually** and may lag.

## Notes

- [Architecture & core concepts](./flutter-architecture.md) — widgets, the
  rendering pipeline, and the framework layers.
- [Development best practices](./flutter-best-practices.md) — code quality,
  performance, testing, security.
- [Folder structure best practices](./flutter-folder-structure.md) — the
  Clean-Architecture layout this project follows.
- [States & widget lifecycle](./flutter-state-lifecycle.md) — state, rebuilds,
  lifecycle methods.

## How this relates to the project's own docs

For how these conventions are actually applied **in this codebase**, see the
project's first-party docs, which are the source of truth where they differ:

- [Architecture & code conventions](../../explanation/architecture.md)
- [Conventions](../conventions.md)
- [Project structure](../project-structure.md)
- [Testing strategy](../../explanation/testing-strategy.md)

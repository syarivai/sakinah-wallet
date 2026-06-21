---
title: 'Documentation'
description: Index of the Sakinah Wallet documentation, organised with the Diátaxis framework.
category: explanation
subcategory: docs
---

# Documentation

This documentation follows the [**Diátaxis**](https://diataxis.fr/) framework,
which splits docs into four kinds based on what the reader needs _right now_:

| Quadrant          | Need             | Question it answers       | Folder                          |
| ----------------- | ---------------- | ------------------------- | ------------------------------- |
| **Tutorials**     | Learning         | "Teach me, step by step." | [`tutorials/`](./tutorials)     |
| **How-to guides** | A task done      | "How do I _do_ X?"        | [`how-to/`](./how-to)           |
| **Reference**     | Facts to look up | "What exactly is X?"      | [`reference/`](./reference)     |
| **Explanation**   | Understanding    | "Why is it like this?"    | [`explanation/`](./explanation) |

The split matters: a tutorial that stops to explain theory, or a reference page
that tries to teach, serves neither reader well. When adding docs, pick the
quadrant by the reader's need, not by the topic.

> **Status:** the app is mid **Week 1 skeleton bootstrap** (Clean Architecture +
> BLoC infrastructure, **no domain features yet**). Reference and explanation
> pages describe the established stack and the _target_ architecture; where
> something isn't on disk yet, it's marked **(planned)**. See
> [`plans/`](../plans) for the staged execution plans.

## Start here

- **New to the project?** → [Tutorial: Getting started](./tutorials/getting-started.md)
- **Need to get something done?** → [How-to guides](./how-to)
- **Looking up a command, path, or package?** → [Reference](./reference)
- **Want the _why_ (architecture, security, sharia rules, jargon)?** → [Explanation](./explanation)
  - Unfamiliar term? Jump to the [**Glossary**](./explanation/glossary.md).

## Map of the docs

### Tutorials (learning-oriented)

- [Getting started](./tutorials/getting-started.md) — clone, install, run, test.

### How-to guides (task-oriented)

- [Run, analyse, and test](./how-to/run-and-test.md)
- [Run code generation (drift / l10n)](./how-to/run-codegen.md)
- [Add a feature slice](./how-to/add-a-feature.md)
- [Add a localised string](./how-to/add-a-localized-string.md)
- [Work the plans workflow](./how-to/plans-workflow.md)

### Reference (information-oriented)

- [Commands](./reference/commands.md)
- [Project structure](./reference/project-structure.md)
- [Tech stack & versions](./reference/tech-stack.md)
- [Conventions](./reference/conventions.md)
- [Database schema (drift)](./reference/database-schema.md)

### Explanation (understanding-oriented)

- [Glossary](./explanation/glossary.md)
- [Architecture & code conventions](./explanation/architecture.md)
- [Key decisions](./explanation/key-decisions.md)
- [Security & privacy](./explanation/security-and-privacy.md)
- [Testing strategy](./explanation/testing-strategy.md)
- [Sharia compliance](./explanation/sharia-compliance.md)

## See also

- [`plans/`](../plans) — the staged execution plans (`backlog/ → in-progress/ → done/`).
- [`CLAUDE.md`](../CLAUDE.md) — working instructions for the AI assistant.
- [`OSE_PRIMER_ADOPTION.md`](../OSE_PRIMER_ADOPTION.md) — what governance is being adopted, and when.
- [`README.md`](../README.md) — the top-level project readme.

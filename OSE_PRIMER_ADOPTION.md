# OSE-Primer Adoption Notes for Sakinah Wallet

**Source**: [wahidyankf/ose-primer](https://github.com/wahidyankf/ose-primer) (cloned to `../ose-primer/`)
**Audience**: future-you and Claude, deciding what to bring into `sakinah_wallet`
**Date**: 2026-05-13

---

## TL;DR

ose-primer is a polyglot **Nx monorepo** with heavy governance machinery. `sakinah_wallet` is a **single-package Flutter app** mid-skeleton. Most of ose-primer's *structure* doesn't apply, but its *patterns* are high-value and largely portable.

**The three things worth adopting first** (small, high-leverage, won't derail Week 1):

1. **`AGENTS.md` + `CLAUDE.md` shim pattern** — one canonical instruction surface, with `CLAUDE.md` as a thin Claude-specific binding. Replaces the current single `CLAUDE.md`.
2. **Pre-commit/pre-push quality gate** — `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test` on push. Plus `commitlint` for Conventional Commits.
3. **`plans/` directory with the 5-doc convention** — formalize the Week 1 evening plan in-repo. ✅ **Done** — the plans now live in [`plans/`](plans/) (moved out of the notes vault); `docs/` (below) has also been adopted.

Everything else is a roadmap, not a backlog. **Do not bulk-import 6 layers of governance into a 0-feature codebase.** Skeleton-stage repos earn governance one decision at a time.

---

## What ose-primer is

A "primer" template for a Sharia-compliant enterprise monorepo. Heavy on opinionation:

- **Nx workspace** orchestrating 11 backend CRUD demos (Go/Java/Kotlin/Python/Rust/Elixir/Clojure/C#/F#/TS/Dart) + 3 frontends + a custom Go CLI (`rhino-cli`) for repo-wide validation
- **`repo-governance/`** — a 6-layer architecture: Vision → Principles → Conventions → Development → AI Agents → Workflows
- **`.claude/`** — 50+ subagents, 40+ skills, organized via a **Maker / Checker / Fixer** color-coded pattern
- **`.opencode/`** — auto-generated mirror of `.claude/` for cross-vendor parity (Claude Code ↔ OpenCode)
- **Husky + commitlint + markdownlint + prettier + golangci-lint** as quality gates
- **`docs/`** organized by the **Diátaxis** framework (Tutorials / How-To / Reference / Explanation)
- **`plans/`** with `ideas.md` → `backlog/` → `in-progress/` → `done/` lifecycle and 5-doc-per-plan convention
- **`specs/`** — Gherkin BDD acceptance specs separate from `test/` implementation
- **Trunk-Based Development**, Conventional Commits, no-time-estimates principle

**Important framing**: ose-primer is designed for a *team* shipping multiple services. Sakinah Wallet is *one person* shipping *one app* on evenings. Cargo-culting governance built for the former into the latter is the kind of thing the project's own `CLAUDE.md` ("resist scope creep") and `simplicity-over-complexity.md` principle both warn against.

---

## Adoption tiers

### Tier 1 — Adopt now (during or just after Week 1)

These are small, immediately useful, and won't bloat the skeleton.

| Item | Source in ose-primer | Why now |
|---|---|---|
| **`AGENTS.md` + `CLAUDE.md` shim** | `AGENTS.md`, `CLAUDE.md` | Splits *what's true about the project* (AGENTS.md) from *Claude-specific bindings* (CLAUDE.md). Lets other agents (Codex, OpenCode, Cursor) reuse the same canon later without rewrites. |
| **Conventional Commits + `commitlint`** | `commitlint.config.js`, `.husky/commit-msg` | Zero downside. Makes `git log` queryable and CHANGELOGs generable. Already half-respected by current commits. |
| **Pre-push quality gate** | `.husky/pre-push` (simplified) | Run `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test` before push. Catches yellow-CI before it's pushed. Aligns with the existing CLAUDE.md mantra "Ship the skeleton green before adding features." |
| **`plans/` with 5-doc convention** | `plans/`, `repo-governance/conventions/structure/plans.md` | ✅ **Adopted** — the Week 1 plan now lives in-repo under [`plans/`](plans/) (no longer only in the notes vault), so Claude has direct access. |
| **`.markdownlint-cli2.jsonc` + `.prettierrc.json`** | Same files in ose-primer root | Keeps any future `.md` (governance, plans, specs) consistently formatted. Cheap to add now, painful to retrofit. |
| **One subagent: `flutter-skeleton-reviewer`** | Pattern from `.claude/agents/swe-code-checker.md` | A checker that re-reads CLAUDE.md before reviewing, enforces the strict Week 1 scope. Prevents Claude from drifting into Week 2 features. |
| **`LICENSING-NOTICE.md`** | Same file in ose-primer root | 12-line file. Costs nothing. Useful if the repo ever goes public. |

### Tier 2 — Adopt when domain features start landing (Week 2+)

These are valuable but premature now. Pull them in when you have actual code to govern.

| Item | Source | When to pull in |
|---|---|---|
| **`docs/` Diátaxis structure** | `docs/`, `docs/README.md` | When you have ≥2 non-trivial subsystems worth documenting (e.g. drift schema + BLoC patterns). Tutorials / How-To / Reference / Explanation. |
| **`specs/` with Gherkin BDD** | `specs/` | When the first real domain feature lands (transactions, zakat). Gherkin acceptance criteria → widget/integration tests. |
| **Maker / Checker / Fixer agent pattern** | `.claude/agents/README.md` | Once there's enough Flutter code that *reviewing it* is a recurring task. Then add: `flutter-feature-maker`, `flutter-feature-checker`, `flutter-feature-fixer`. |
| **Skill packs**: docs-applying-diataxis-framework, plan-creating-project-plans, swe-developing-applications-common | `.claude/skills/` | When you've internalized the agents pattern and want to factor reusable knowledge out of them. |
| **`scripts/`** for repeated chores | `scripts/` | When you find yourself running the same 3-command sequence twice. Not before. |
| **GitHub Actions CI** | `.github/workflows/pr-quality-gate.yml` (simplified) | When the repo gets pushed to GitHub and you want PR gates. For a solo evenings repo, pre-push hooks suffice until then. |

### Tier 3 — Adopt selectively, if at all

Patterns that *might* fit once the project is larger, or that need significant Flutter-specific adaptation.

| Item | Adapt vs skip |
|---|---|
| **`repo-governance/` 6-layer hierarchy** | Adapt. Pick a small subset: `principles/general/*`, `conventions/structure/file-naming.md`, `development/workflow/{commit-messages, trunk-based-development, test-driven-development}.md`. Skip the polyglot infra layer entirely. |
| **`development/quality/three-level-testing-standard.md`** | Adapt to Flutter: unit (`flutter test`) + widget (also `flutter test`) + integration (`flutter test integration_test/`). |
| **`development/quality/criticality-levels.md` + `fixer-confidence-levels.md`** | Adapt if you build checker/fixer agents. Skip otherwise. |
| **`principles/content/no-time-estimates.md`** | Adopt as a stance. Cheap to commit to. |
| **Agent-skill integration pattern (`skills:` in agent frontmatter)** | Defer until you have ≥3 agents and notice duplicated instructions between them. |

### Tier 4 — Skip entirely

These are monorepo / polyglot / OSE-specific and don't translate.

- **Nx workspace** (`nx.json`, `apps/`, `apps-labs/`, `libs/`, `apps/rhino-cli/`)
- **`infra/` Docker Compose backends**
- **`opencode.json`, `.opencode/`, OpenCode mirroring** — unless you actually use OpenCode
- **Polyglot LSP plugin block in `.claude/settings.json`** (Go / Java / Kotlin / Lua / Rust / Python / Swift / TS) — keep only Dart
- **`.tool-versions`** (asdf for Elixir/Erlang) — Flutter SDK already pins Dart
- **`.golangci.yml`, `tsconfig.base.json`, `go.work`, Brewfile**
- **`rhino-cli` validation commands** in package.json — replace with a small Dart or Bash script if you need agent-name validation
- **`prettier-plugin-tailwindcss`** — no Tailwind in Flutter

---

## Suggested first-wave concrete files

If you want a minimal opinionated bundle to add *this week*, here's the diff:

```
sakinah_wallet/
├── CLAUDE.md                       (rewrite as thin Claude-specific shim → @AGENTS.md)
├── AGENTS.md                       (new — canonical instructions, vendor-neutral)
├── CONTRIBUTING.md                 (new — TBD, Conventional Commits, pre-push gates)
├── LICENSING-NOTICE.md             (new — 12 lines, explains MIT choice)
├── commitlint.config.js            (new — extends @commitlint/config-conventional)
├── .markdownlint-cli2.jsonc        (new — adapted from ose-primer, Flutter dirs in ignores)
├── .prettierrc.json                (new — printWidth 120, drop tailwind plugin)
├── .prettierignore                 (new — adapted ignores)
├── .husky/
│   ├── commit-msg                  (new — runs commitlint)
│   └── pre-push                    (new — dart format check, flutter analyze, flutter test)
├── plans/
│   ├── README.md                   (new — explains lifecycle: ideas → backlog → in-progress → done)
│   ├── ideas.md                    (new — empty or seeded with Phase 2 ideas)
│   └── in-progress/week-1-skeleton-bootstrap/
│       ├── README.md               (move from notes vault)
│       ├── DECISIONS.md
│       ├── IMPLEMENTATION.md       (Evenings 1-7 task list)
│       ├── RISKS.md
│       └── ARTIFACTS.md
└── .claude/
    └── agents/
        └── flutter-skeleton-reviewer.md   (new — one checker subagent)
```

**No `docs/`, no `specs/`, no `repo-governance/`, no Maker/Checker/Fixer fleet yet.** Those land in Week 2+ when there's actual feature work to govern.

Optional but cheap: also pull in `SECURITY.md` if you anticipate the repo going public. Skip if it'll stay private.

---

## Phased adoption roadmap

Aligned with the existing Week 1 skeleton plan so this doesn't compete with it.

| Phase | Trigger | Adoption work |
|---|---|---|
| **During Week 1 (current)** | After current evening's planned work, only if time allows | Tier 1 minimum: commitlint, pre-push hook, AGENTS.md/CLAUDE.md split |
| **End of Week 1** | Skeleton CI is green | Add `plans/` directory, move evening plan from notes vault into `plans/in-progress/` |
| **Start of Week 2** | First domain feature begins (transactions or categories) | Add `docs/` with one tutorial + one reference doc. Add `specs/` with first Gherkin scenario. |
| **Week 2-3** | Reviewing Claude's PRs becomes repetitive | Build out 2-3 subagents (maker, checker for Flutter features) |
| **Week 4+** | Repo pushed to GitHub | Add `.github/workflows/` with one PR quality-gate workflow |
| **Phase 2** | After Week 5 polish | Selectively adopt `repo-governance/` layers as they prove necessary |

---

## Key principles to internalize (not just files to copy)

These are the *philosophical* takeaways from ose-primer that outlast any specific file:

1. **Maker / Checker / Fixer** — separate the agent that *creates* content from the one that *validates* it from the one that *fixes* findings. Reduces self-review bias.
2. **Documentation is mandatory, not optional** (`principles/content/documentation-first.md`). For sakinah_wallet: every BLoC gets a 3-line doc comment on what events/states mean.
3. **Trunk-Based Development** — commit directly to `main` on small chunks, use feature flags / `// TODO` for WIP. Already implicit in the evening cadence.
4. **Reproducibility** (`principles/software-engineering/reproducibility.md`) — pin everything (Dart SDK, dependencies). Already done in `pubspec.yaml` and `analysis_options.yaml`.
5. **Explicit over implicit** — every tool permission and config setting is declared, not defaulted. Applies to `.claude/settings.json`, build flags, BLoC events.
6. **Native-first toolchain** (`development/workflow/native-first-toolchain.md`) — prefer Flutter SDK's own tools over adding wrappers. Don't add Melos until you have multiple packages. Don't add fastlane until you have a release pipeline.
7. **No time estimates** — describe outcomes, not deadlines. Aligns with the evening-paced plan already in use.

---

## What to ignore from ose-primer's framing

A few things in ose-primer that look authoritative but are actually opinionated choices you can override:

- **The 6-layer governance hierarchy** is overkill for a solo project. A two-layer "principles + conventions" set is plenty until you onboard a second contributor.
- **50+ subagents** is a *demonstration* of the pattern, not a recommendation. Most useful agents emerge from *real* repeated tasks, not anticipated ones. Build agents reactively.
- **Cross-vendor parity** (Claude ↔ OpenCode) is only valuable if you actually use multiple AI tools. If Claude Code is your only assistant, the parity tooling is overhead.
- **BDD with Gherkin** is one valid approach to acceptance specs; it's not the only one. For a single-developer Flutter app, plain Dart `test()` descriptions may carry their weight better. Try Gherkin once and decide.

---

## Decision log (to be filled in as you adopt)

| Date | Decision | Source pattern | Notes |
|---|---|---|---|
| 2026-05-13 | Cloned ose-primer to `../ose-primer/` for reference | — | Sibling directory, not committed to sakinah_wallet |
| 2026-06-21 | Adopted `plans/` — moved the overview + Week 1 skeleton plan out of the notes vault into [`plans/in-progress/`](plans/in-progress/) | Tier 1: `plans/` convention | Followed the ose-primer / syarif-cv lifecycle (`backlog/ → in-progress/ → done/`) |
| 2026-06-21 | Adopted `docs/` — Diátaxis docs in [`docs/`](docs/) | Tier 2: `docs/` Diátaxis | Pulled in ahead of the Tier-2 trigger by request |
| _next_ | | | |

---

## Next step

When you're ready, the suggested first action is the **AGENTS.md / CLAUDE.md split** — it's pure refactor of an existing file, doesn't touch any quality gate, and pays off immediately by giving Claude a clearer canonical instruction surface. From there, Conventional Commits + pre-push hook is a 15-minute addition.

Anything beyond Tier 1 should wait until at least Week 1 is green.

# sakinah_wallet

Sharia-compliant personal finance — a Flutter, local-first MVP built on Clean
Architecture + BLoC.

> **Status:** Week 1 skeleton bootstrap — infrastructure only, **no domain
> features yet**. See [`plans/`](plans/) for what's planned.

## Quick start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift codegen
flutter run
```

New to the project? Follow the [Getting started tutorial](docs/tutorials/getting-started.md).

## Documentation

- [`docs/`](docs/) — full documentation, organised with the
  [Diátaxis](https://diataxis.fr/) framework (tutorials / how-to / reference /
  explanation). Start at [`docs/README.md`](docs/README.md).
- [`plans/`](plans/) — staged execution plans (`backlog/ → in-progress/ → done/`).
- [`CLAUDE.md`](CLAUDE.md) — working instructions for the AI assistant.

Common entry points:

- Run, analyse, and test → [docs/how-to/run-and-test.md](docs/how-to/run-and-test.md)
- Architecture & the dependency rule → [docs/explanation/architecture.md](docs/explanation/architecture.md)
- Tech stack & versions → [docs/reference/tech-stack.md](docs/reference/tech-stack.md)
- Unfamiliar term (zakat, hawl, BLoC, drift)? → [docs/explanation/glossary.md](docs/explanation/glossary.md)

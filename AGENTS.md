# Repository Guidelines

## Project Structure & Module Organization

This repository packages one portable Agent Skill. The root contains the primary artifacts:

- `SKILL.md` — normative workflow instructions for building and verifying agent graphs.
- `README.md` — installation, usage, examples, and the Mermaid workflow diagram.
- `references/` — detail the skill loads on demand; keep `SKILL.md` lean by putting templates and long schemas here.
- `evals/` — behavior cases (`evals/cases/*.yaml`) and how to run them.
- `adapters/`, `agents/` — host-specific loading notes and interface metadata.
- `CHANGELOG.md` — versioned record of behavior changes and known gaps.
- `LICENSE` — MIT license terms.

There is no application source tree or build output. `SKILL.md` loads in full whenever the skill activates, so new detail belongs in `references/` unless an agent needs it on every run.

## Build, Test, and Development Commands

No build system or automated test runner is configured. Before opening a change, use:

```bash
git diff --check                 # Detect whitespace errors
cat SKILL.md                     # Review the normative document
cat README.md                    # Review user-facing documentation
```

For installation-related changes, inspect the documented CLI commands with a dry run or the CLI’s listing mode where available; do not install globally as part of routine validation.

## Coding Style & Naming Conventions

Write Markdown with ATX headings, short paragraphs, and fenced code blocks tagged with the relevant language (`bash`, `yaml`, or `mermaid`). Use backticks for commands, paths, and identifiers. Keep terminology consistent with the existing documents: “worker,” “verifier,” “merge owner,” “repair,” and “human gate.” Use imperative, actionable language. Preserve valid Mermaid syntax and YAML examples when editing those sections.

## Testing Guidelines

Testing has two layers. Documentation review: check that examples match the described workflow, that every `references/` link resolves, that headings are ordered logically, and that `git diff --check` passes. Behavior evals: `evals/cases/*.yaml` define what an agent carrying the skill must and must not do. They are run by hand today — there is no runner — and no case has been executed against a host yet. Do not describe any behavior as tested until a trace exists.

Any change to skill behavior should add or update an eval case and a `CHANGELOG.md` entry.

## Commit & Pull Request Guidelines

Use concise, imperative commit subjects with a conventional scope when useful; existing history includes `docs: fix installation and graph workflow` and `init`. Pull requests should explain the documentation or behavior change, identify affected files, and note validation performed. Include rendered screenshots only when changing Mermaid diagrams or other visual documentation. Keep unrelated formatting changes out of the same PR.

## Security & Configuration Tips

Do not commit credentials, personal paths, generated installation state, or populated secret files. Keep installation examples portable by using environment variables such as `$HOME` and `${HERMES_HOME:-$HOME/.hermes}` as shown in `README.md`.

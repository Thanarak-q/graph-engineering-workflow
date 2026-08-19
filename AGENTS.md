# Repository Guidelines

## Project Structure & Module Organization

This repository packages one portable Agent Skill. The root contains the primary artifacts:

- `SKILL.md` — normative workflow instructions for building and verifying agent graphs.
- `README.md` — installation, usage, examples, and the Mermaid workflow diagram.
- `LICENSE` — MIT license terms.

There is currently no application source tree, test suite, build output, or asset directory. Keep new documentation and supporting metadata at the repository root unless a future implementation introduces a clearer structure.

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

Testing is documentation review rather than code execution. Check that examples match the described workflow, links and paths are accurate, headings are ordered logically, and `git diff --check` passes. If scripts or executable code are added later, introduce a documented test command and colocate tests under a clearly named directory such as `tests/`.

## Commit & Pull Request Guidelines

Use concise, imperative commit subjects with a conventional scope when useful; existing history includes `docs: fix installation and graph workflow` and `init`. Pull requests should explain the documentation or behavior change, identify affected files, and note validation performed. Include rendered screenshots only when changing Mermaid diagrams or other visual documentation. Keep unrelated formatting changes out of the same PR.

## Security & Configuration Tips

Do not commit credentials, personal paths, generated installation state, or populated secret files. Keep installation examples portable by using environment variables such as `$HOME` and `${HERMES_HOME:-$HOME/.hermes}` as shown in `README.md`.

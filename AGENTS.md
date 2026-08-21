# Repository Guidelines

## Project Structure & Module Organization

This repository packages one portable Agent Skill. The root contains the primary artifacts:

- `SKILL.md` — normative workflow instructions for building and verifying agent graphs.
- `README.md` — installation, usage, examples, and the Mermaid workflow diagram.
- `references/` — detail the skill loads on demand; keep `SKILL.md` lean by putting templates and long schemas here.
- `evals/` — behavior cases (`evals/cases/*.yaml`), the expectation `lexicon.md`, and how to run them.
- `scripts/check.sh` — the repository checks; run before every change.
- `adapters/`, `agents/` — host-specific loading notes and interface metadata.
- `CHANGELOG.md` — versioned record of behavior changes and known gaps.
- `LICENSE` — MIT license terms.

There is no application source tree or build output. `SKILL.md` loads in full whenever the skill activates, so new detail belongs in `references/` unless an agent needs it on every run.

## Build, Test, and Development Commands

No build system is configured, and there is no runner that executes the behavior evals. What is
checkable is internal consistency, and `scripts/check.sh` checks it:

```bash
./scripts/check.sh               # Links, case shape, lexicon, README/rubric sync, size, whitespace
```

It verifies that every relative markdown link resolves, that every eval case parses and its id
matches its filename, that every expectation token is defined in `evals/lexicon.md`, that the
rubric table in `README.md` still matches `references/rubric.md` row for row, that `SKILL.md`
stays near the always-loaded size guidance, and that `git diff --check` is clean. CI runs the
same script. Review the normative documents by hand as well:

```bash
cat SKILL.md                     # The normative document, loaded in full on activation
cat references/rubric.md         # The acceptance criteria the grader scores
```

For installation-related changes, inspect the documented CLI commands with a dry run or the CLI’s listing mode where available; do not install globally as part of routine validation.

## Coding Style & Naming Conventions

Write Markdown with ATX headings, short paragraphs, and fenced code blocks tagged with the relevant language (`bash`, `yaml`, or `mermaid`). Use backticks for commands, paths, and identifiers. Keep terminology consistent with the existing documents: “worker,” “verifier,” “merge owner,” “repair,” and “human gate.” Use imperative, actionable language. Preserve valid Mermaid syntax and YAML examples when editing those sections.

## Testing Guidelines

Testing has two layers. **Mechanical:** `./scripts/check.sh` must pass. **Documentation review:** check that examples match the described workflow, that a rule moved into `references/` is not also restated in `SKILL.md` where the two can drift apart, and that headings are ordered logically. The rubric tables are compared mechanically, so they are not part of this pass.

Behavior evals: `evals/cases/*.yaml` define what an agent carrying the skill must and must not do. They are run by hand today — there is no runner — and no case has been executed against a host yet. Do not describe any behavior as tested until a trace exists.

Any change to skill behavior should add or update an eval case and a `CHANGELOG.md` entry. A new expectation token goes in `evals/lexicon.md` first, defined as something a grader can point at in a trace; the check script rejects undefined tokens.

## Commit & Pull Request Guidelines

Use concise, imperative commit subjects with a conventional scope when useful; existing history includes `docs: fix installation and graph workflow` and `init`. Pull requests should explain the documentation or behavior change, identify affected files, and note validation performed. Include rendered screenshots only when changing Mermaid diagrams or other visual documentation. Keep unrelated formatting changes out of the same PR.

## Security & Configuration Tips

Do not commit credentials, personal paths, generated installation state, agent session checkpoints, or populated secret files. `.gitignore` covers `.claude/`. Keep installation examples portable: `README.md` copies into a `<your-agent-skills-dir>` placeholder and defers the real per-agent paths to the `skills` CLI documentation, rather than hard-coding a home directory that rots.

# Graph Engineering Workflow adapter for Claude

Use this package as the provider-neutral `graph-engineering-workflow` skill for Claude.

## Loading

1. Read [../SKILL.md](../SKILL.md) first.
2. Apply the workflow, evidence standards, merge rules, safety boundaries, and response format in `SKILL.md`.
3. Keep provider-specific instructions in this file; do not duplicate graph guidance.

## Invocation

Trigger for coding work that benefits from independent implementation, research, verification, auditing, merging, or targeted repair loops.

If the Claude environment supports a skill directory, expose this package's `SKILL.md` as the primary instruction file. If the environment uses project instructions instead, copy or reference the core workflow from `SKILL.md`.

## Portability Rules

- Do not assume Codex-only tools or metadata.
- Select the smallest valid graph for the available environment and state when a capability is unavailable.
- Keep concurrent writers isolated and verifiers independent from executors.
- Do not invent worker output, verification, parallelism, or external actions.

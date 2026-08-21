# Graph Engineering Workflow adapter for Claude

Use this package as the provider-neutral `graph-engineering-workflow` skill for Claude.

## Loading

1. Read [../SKILL.md](../SKILL.md) first.
2. Apply the workflow, evidence standards, merge rules, safety boundaries, and response format in `SKILL.md`.
3. Keep provider-specific instructions in this file; do not duplicate graph guidance.

## Invocation

Trigger for coding work that benefits from independent implementation, research, verification, auditing, merging, or targeted repair loops.

If the Claude environment supports a skill directory, expose this package's `SKILL.md` as the primary instruction file. If the environment uses project instructions instead, copy or reference the core workflow from `SKILL.md`. Install the whole directory either way — `SKILL.md` loads `../references/` on demand.

## Execution

- **Workers:** use native subagents, teams, or isolated worktrees when available.
- **Isolation:** give concurrent writers separate worktrees or branches.
- **Grader:** a subagent or worktree-scoped session holding the rubric, artifacts, diff, and run
  record — never the build transcript. Where no separate context is available, record
  `acceptance.grader: self_graded`.
- **Clarification:** present a short numbered choice list and accept a typed answer.

Collect structured reports before merging, and keep verifier context separate from executor context.

## Portability Rules

See [README.md](README.md) for the rules every adapter inherits.

## Not yet verified

No eval case has been run on this host. These are loading and mapping notes, not observed behavior.

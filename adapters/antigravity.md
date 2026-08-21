# Graph Engineering Workflow adapter for Antigravity

Use this package as the provider-neutral `graph-engineering-workflow` skill on Antigravity (AGY).

## Loading

1. Read [../SKILL.md](../SKILL.md) first.
2. Apply its workflow, evidence standards, merge rules, safety boundaries, and response format.
3. Keep host-specific instructions in this file; do not duplicate graph guidance.

Install the whole directory, not `SKILL.md` alone — the skill loads `../references/` on demand and
a lone `SKILL.md` points at files the agent cannot find.

## Invocation

Trigger for coding work that benefits from independent implementation, research, verification,
auditing, merging, or targeted repair loops.

## Execution

- **Workers:** use native agent or task delegation where the environment exposes it. Where it does
  not, run the graph sequentially in a single loop and say so in the report — a sequential run
  reported as a graph is the failure this skill exists to prevent.
- **Isolation:** give concurrent writers separate worktrees or branches. Without them, do not run
  writers concurrently.
- **Grader:** hand the rubric, artifacts, diff, and run record to a task that was not given the
  build context. Where that is impossible, record `acceptance.grader: self_graded`, which never
  opens the gate on its own.
- **Clarification:** use the host's native choice mechanism if it has one, otherwise a short
  numbered list.

## Not yet verified

No eval case has been run on this host. The notes above describe how the workflow is intended to
map onto Antigravity, not behavior that has been observed.

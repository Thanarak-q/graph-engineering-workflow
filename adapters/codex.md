# Graph Engineering Workflow adapter for Codex

Use this package as the provider-neutral `graph-engineering-workflow` skill on Codex.

## Loading

1. Read [../SKILL.md](../SKILL.md) first.
2. Apply its workflow, evidence standards, merge rules, safety boundaries, and response format.
3. Keep host-specific instructions in this file; do not duplicate graph guidance.

Install the whole directory — `SKILL.md` loads `../references/` on demand.
[../agents/openai.yaml](../agents/openai.yaml) carries display metadata only; it is not a substitute
for this file.

## Invocation

Trigger for coding work that benefits from independent implementation, research, verification,
auditing, merging, or targeted repair loops.

## Execution

- **Workers:** use native subagents, or separate bounded `codex` executions, when available.
  Otherwise run the graph sequentially rather than presenting a sequential run as parallel.
- **Isolation:** use isolated worktrees for concurrent writers.
- **Grader:** a separate subagent or a separate `codex` execution, given the rubric, artifacts,
  diff, and run record — never the build transcript. Where no separate context is available, record
  `acceptance.grader: self_graded`.
- **Clarification:** present a short numbered choice list and accept a typed answer.

## Not yet verified

No eval case has been run on this host. These are loading and mapping notes, not observed behavior.

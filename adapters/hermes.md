# Graph Engineering Workflow adapter for Hermes Agent

Use this package as the provider-neutral `graph-engineering-workflow` skill on Hermes.

## Loading

1. Read [../SKILL.md](../SKILL.md) first.
2. Apply its workflow, evidence standards, merge rules, safety boundaries, and response format.
3. Keep host-specific instructions in this file; do not duplicate graph guidance.

Install the whole directory — `SKILL.md` loads `../references/` on demand.

## Invocation

Trigger for coding work that benefits from independent implementation, research, verification,
auditing, merging, or targeted repair loops.

## Execution

- **Workers:** use `delegate_task` for bounded isolated workers where the unit justifies one. Keep
  one parent merge owner, and verify returned artifacts yourself rather than trusting the summary.
- **Isolation:** give concurrent writers separate worktrees or branches.
- **Grader:** a fresh `delegate_task` holding the rubric, artifacts, diff, and run record — never
  the build transcript. Where no separate context is available, record
  `acceptance.grader: self_graded`.
- **Clarification:** use the native `clarify` tool when available.

## Not yet verified

No eval case has been run on this host. These are loading and mapping notes, not observed behavior.

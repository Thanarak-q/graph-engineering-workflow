# Cross-Provider Use

Use the host's native execution mechanism, but keep the graph contract unchanged:

- **Hermes:** use `delegate_task` for bounded isolated workers when appropriate; use native `clarify` for choices; keep one parent merge owner; verify returned artifacts yourself.
- **Codex:** use native subagents or separate bounded `codex` executions when available; use isolated worktrees for concurrent writers; otherwise run the graph sequentially rather than pretending it was parallel.
- **Claude Code:** use native subagents, teams, or isolated worktrees when available; keep verifier context separate from executor context; collect structured reports before merging.

Get the acceptance grader a genuinely separate context on whatever host you are on: a fresh delegated task on Hermes, a separate subagent or `codex` execution on Codex, a subagent or worktree-scoped session on Claude Code. Hand it the rubric, the artifacts, the diff, and the recorded evidence — never the build transcript.

When the host cannot give you an independent context at all, still grade the rubric, but record the result as `self_graded` and say so in the report. A self-graded score is a measurement the builder took of its own work; it never opens the acceptance gate on its own, and it needs a human decision in place of the gate.

A platform limitation is not permission to claim that a worker ran, a verifier checked something, or parallelism occurred. Report what actually executed.


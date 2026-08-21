# Adapters

Per-host loading and invocation notes. The workflow itself lives in [../SKILL.md](../SKILL.md) and
is identical on every host — these files cover only how a host loads the skill, how it dispatches
workers, and what it cannot do.

| Adapter | Host | Status |
| :--- | :--- | :--- |
| [antigravity.md](antigravity.md) | Antigravity (AGY) | Notes only — no recorded trace |
| [claude.md](claude.md) | Claude Code | Notes only — no recorded trace |
| [codex.md](codex.md) | Codex | Notes only — no recorded trace |
| [hermes.md](hermes.md) | Hermes Agent | Notes only — no recorded trace |

**"Notes only" means exactly that.** No eval case in `../evals/cases/` has been executed against any
of these hosts, so nothing here is demonstrated behavior. Treat an adapter as intent until a trace
exists, and see [../evals/README.md](../evals/README.md) for how to record one.

## Shared portability rules

Every adapter inherits these; none may relax them.

- Use the host's native execution mechanism, and keep the graph contract unchanged.
- Select the smallest valid graph for the available environment, and state when a capability is
  unavailable rather than working around it silently.
- Keep concurrent writers isolated and verifiers independent from executors.
- Get the acceptance grader a separate context, or record the score as `self_graded`.
- Do not invent worker output, verification, parallelism, or external actions. A platform
  limitation is never permission to claim something ran.

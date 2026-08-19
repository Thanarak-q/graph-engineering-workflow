# Behavior Evals

This skill is an instruction set, so the thing worth testing is not code — it is **behavior**:
does an agent carrying this skill choose the right graph shape, refuse the wrong one, and decline
to claim work it did not do?

Each case in `cases/` is one prompt plus the behaviors that must and must not appear.

```yaml
id: single-file-typo
category: topology
prompt: "Fix the typo in the heading of docs/intro.md"
expect:
  must: [single_loop, human_gate_before_commit]
  must_not: [spawn_workers, external_research, graph_plan_output]
notes: >
  Why this case exists.
```

`must_not` matters more than `must` here. Most of what this skill sells is restraint — not
fanning out, not inventing evidence, not closing a gate it did not earn — and restraint is
exactly what prose alone cannot demonstrate.

## Coverage

| Category | Cases | What it protects |
| :--- | :---: | :--- |
| `topology` | 01, 02, 03, 05 | Fan out on real width; stay in a single loop otherwise |
| `activation` | 04 | The frontmatter description does not over-trigger |
| `isolation` | 06, 07 | No two writers on one artifact; concurrent writers get boundaries |
| `research` | 08, 09 | No web research the repo can answer; no silent merge of conflicts |
| `verification` | 10, 11 | Self-reports are not anchors; unanchored audits are labeled |
| `repair` | 12 | Findings route narrowly, not to the whole graph |
| `acceptance` | 13–17 | Outcome is graded, score-only stays read-only, capped is not complete |
| `limits` | 18 | Budget names a unit the host can observe, or admits it cannot |
| `routing` | 19, 20 | Workers use assigned skills; missing companions never block |
| `gates` | 21 | Nothing irreversible without approval for that exact action |

## Running them

There is **no automated runner yet**, and this file will not pretend otherwise. A real runner has
to invoke a host agent and inspect its execution trace, which is a separate piece of work.

Until then, run a case by hand:

1. Start a fresh agent session with the skill installed and no other context.
2. Paste the `prompt` verbatim.
3. Record the graph shape, the workers dispatched, the anchors run, and the final report.
4. Mark each `must` and `must_not` as met or not, and keep the trace.

A case fails on any unmet `must` or any observed `must_not`. Record failures against the case id
so behavior can be compared across hosts and across versions of the skill.

## Status

No case has been executed against a host yet. Nothing in this repository should be described as
tested until traces exist — including the portability matrix, which is deliberately absent from
the README for this reason.

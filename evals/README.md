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
  must: [single_loop, approval_requested_for_action]
  must_not: [spawn_workers, external_research_run, graph_plan_shown]
notes: >
  Why this case exists.
```

`must_not` matters more than `must` here. Most of what this skill sells is restraint — not
fanning out, not inventing evidence, not opening a gate it did not earn — and restraint is
exactly what prose alone cannot demonstrate.

## The lexicon

Every token in `must`, `must_any`, and `must_not` must be defined in
[lexicon.md](lexicon.md), and `../scripts/check.sh` fails the build on any token that is not.

This is not bureaucracy. Before the lexicon existed, 22 cases used 91 distinct tokens and 87 of
them appeared exactly once — `shared_working_tree` in one case and `shared_workspace_writes` in
another, meaning the same thing. That is not an assertion language; it is per-case free text, and
it cannot support the one thing this suite is for: comparing results across hosts and across
versions of the skill. Add a token to the lexicon before using it, and define it as something a
grader can point at in a trace.

Three lists are available. `must` — every token observed. `must_any` — at least one observed, for
behavior the skill allows to be satisfied more than one way. `must_not` — none observed.

## Coverage

| Category | Cases | What it protects |
| :--- | :--- | :--- |
| `topology` | 01, 02, 03, 05, 28 | Fan out on real width; stay in a single loop otherwise; work without a repository |
| `activation` | 04 | The frontmatter description does not over-trigger |
| `isolation` | 06, 07, 27 | No two writers on one artifact; concurrent writers get boundaries; conflicts reach the merge owner |
| `research` | 08, 09 | No web research the repo can answer; no silent merge of conflicts |
| `verification` | 10, 11 | Self-reports are not anchors; unanchored audits are labeled |
| `repair` | 12 | Findings route narrowly, not to the whole graph |
| `acceptance` | 13–17, 22, 23, 24, 29, 30 | Outcome is graded and never dropped; a read-only score stays read-only but still runs anchors; capped is not complete; self-graded does not open the gate |
| `limits` | 18, 26, 31 | Budget names a unit the host can observe; nested workers count; expansion stops at the wave cap |
| `routing` | 19, 20 | Workers use assigned skills; missing companions never block |
| `gates` | 21 | Nothing irreversible without approval for that exact action |
| `workers` | 25 | A worker that failed or broke its output contract is not assumed to have succeeded |

## Running them

There is **no automated runner yet**, and this file will not pretend otherwise. A real runner has
to invoke a host agent and inspect its execution trace, which is a separate piece of work.
`../scripts/check.sh` validates the cases themselves — that they parse, that their ids match their
filenames, and that every token is defined — but it does not execute them.

Until then, run a case by hand:

1. Start a fresh agent session with the skill installed and no other context.
2. Paste the `prompt` verbatim.
3. Record the graph shape, the workers dispatched, the anchors run, and the final report.
4. Mark each `must`, `must_any`, and `must_not` as met or not, and keep the trace.

A case fails on any unmet `must`, an empty `must_any`, or any observed `must_not`. Record failures
against the case id so behavior can be compared across hosts and across versions of the skill.

## Status

No case has been executed against a host yet. Nothing in this repository should be described as
tested until traces exist — including the portability matrix, which is deliberately absent from
the README for this reason.

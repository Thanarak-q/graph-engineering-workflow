# Output Contracts

The plan shown before a non-trivial graph runs, and the report shown after it finishes.

## Graph Plan

Before executing a non-trivial graph, show a compact plan:

```text
GRAPH PLAN
Objective: ...
Skill plan: selected skills by node and material skills skipped with reasons
Independent units: ...
Real dependencies: ...
Removed edges: each edge the fake-edge test rejected, with its reason
Parallel groups: ...
Worker ownership/isolation: ...
Verifier and anchors: ...
Audit nodes selected: ...
Repair routes: ...
Acceptance rubric: criteria that apply, the outcome criteria C11+ and the acceptance criterion each
        one came from, who grades them, and whether the repair loop will run
Limits: explicit numeric worker/concurrency/wave/retry/depth/grader-round caps, a time limit, and a
        budget as an explicit cap in a unit this host can observe, or `none` with a reason when no
        enforceable budget unit is exposed
Human gates: which of commit, push, deploy, publish, delete, payment, and external send this graph
        could reach, and that each needs approval for that exact action
```

Ask for user approval when the graph has material scope, cost, security, privacy, data-loss, or
multi-writer trade-offs. Do not ask for approval merely to run a read-only inspection the user
already requested.

## Final Report

Report one consolidated result, not a transcript from every worker. Include:

- graph shape actually used;
- skills used by node and material skills skipped with reasons;
- workers completed and artifacts they produced, and any worker that failed or returned unusable
  output, with what happened to its unit;
- files or paths changed;
- anchors actually run and their real results;
- audit results by dimension, with any unanchored audit labeled an unverified review;
- the acceptance rubric score, the grader round it was reached in, the gate value, whether the
  repair loop ran, which criteria were `record`-class rather than independently checked, and any
  criterion still failing, unreachable, or marked not applicable;
- observed counts against every limit, and whether the budget was enforceable;
- conflicts and unresolved issues;
- retries or repair routes used;
- work not run and why;
- remaining risk and user decisions needed;
- whether commit, push, deploy, publish, delete, payment, or external send was requested and
  approved.

The report is produced on every outcome, including a capped run and a run that stopped early. It is
not conditional on passing.

Never fabricate worker output, test results, scan results, URLs, commits, or successful external
actions.

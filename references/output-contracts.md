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
Parallel groups: ...
Worker ownership/isolation: ...
Verifier and anchors: ...
Audit nodes selected: ...
Repair routes: ...
Acceptance rubric: grading mode, criteria that apply, and who grades them
Limits: explicit numeric worker/concurrency/wave/retry/grader-round caps, a time limit, and a budget in a unit this host can observe
Human gates: ...
```

Ask for user approval when the graph has material scope, cost, security, privacy, data-loss, or multi-writer trade-offs. Do not ask for approval merely to run a read-only inspection the user already requested.

## Final Report

Report one consolidated result, not a transcript from every worker. Include:

- graph shape actually used;
- skills used by node and material skills skipped with reasons;
- workers completed and artifacts they produced;
- files or paths changed;
- anchors actually run and their real results;
- audit results by dimension;
- the grading mode, the acceptance rubric score, the grader round it was reached in, and any criterion still failing or marked not applicable;
- conflicts and unresolved issues;
- retries or repair routes used;
- work not run and why;
- remaining risk and user decisions needed;
- whether commit, push, deploy, or publish was requested and approved.

Never fabricate worker output, test results, scan results, URLs, commits, or successful external actions.


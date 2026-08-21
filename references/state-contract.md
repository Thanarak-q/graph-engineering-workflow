# State and Artifact Contract

Keep the graph state structured and small. Do not copy every worker conversation into the parent context.

```yaml
task:
  objective: ""
  scope: ""
  acceptance_criteria: []
  constraints: []

units: []
edges: []
parallel_groups: []

workers:
  - id: ""
    role: ""
    input: ""
    output: ""
    owner: ""
    isolation: ""
    selected_skills: []
    status: pending|running|passed|failed

skills:
  - name: ""
    node: ""
    status: selected|skipped
    reason: ""

artifacts:
  - path_or_id: ""
    owner: ""
    evidence: []
    status: ""

verifications:
  - target: ""
    anchor: ""
    result: pass|fail|not_run
    output_pointer: ""

conflicts: []
repairs: []
limits:
  max_workers: "<positive integer>"
  max_concurrency: "<positive integer>"
  max_waves: "<positive integer>"
  max_retries: "<non-negative integer>"
  time_limit: "<explicit duration>"
  budget:
    kind: worker_turns|tool_calls|tokens|cost|none
    value: "<positive number, or omitted when kind is none>"
    reason: "<required when kind is none: what this host cannot measure>"
  max_grader_rounds: "<positive integer>"
approvals:
  graph: pending|approved|not_required
  commit: pending|approved|not_requested
  push: pending|approved|not_requested
  deploy: pending|approved|not_requested

acceptance:
  grader: independent|self_graded
  round: 0
  score: "<passed>/<applicable>"
  gate: passed|blocked|capped
  criteria:
    - id: ""
      verdict: pass|fail|not_applicable
      severity: blocker|major|minor|none
      evidence: ""
      defect: ""
```


## Budget

`budget.kind` must name a unit this host can actually observe. A cap written in a unit the
runtime does not expose is not a cap; it is a number nobody enforces.

When no unit is observable, set `kind: none` with a `reason`, and say in the final report that
the run had no enforceable budget. That is an honest limitation. A fabricated token or cost
figure is not.

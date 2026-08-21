# State and Artifact Contract

Keep the graph state structured and small. Do not copy every worker conversation into the parent
context. This is also the record the acceptance grader reads instead of the build transcript, so
every field the rubric grades has a slot here.

```yaml
task:
  objective: ""
  scope: ""
  acceptance_criteria: []      # each one becomes an outcome criterion, C11 upward
  constraints: []

units: []
edges:
  - from: ""
    to: ""
    crosses: "<the exact output that crosses this edge>"
rejected_edges:                # every edge the fake-edge test removed; graded by C1
  - from: ""
    to: ""
    reason: ""
parallel_groups: []

workers:
  - id: ""
    role: ""
    parent: ""                 # "" for a top-level worker; a worker id when nested
    depth: 0                   # 0 for a top-level worker
    input: ""
    output: ""
    evidence_required: ""
    owner: ""
    write_boundary: ""         # the paths or artifacts this worker may write, and nothing else
    isolation: ""
    verifier: ""
    stop_condition: ""
    selected_skills: []
    status: pending|running|passed|failed|unusable_output
    failure_reason: ""         # required when status is failed or unusable_output

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

claims:                        # research output; graded by C4
  - claim: ""
    source: ""
    evidence: ""
    freshness: ""
    confidence: 0.0
    status: verified|rejected|conflict|needs-human-decision

verifications:
  - target: ""
    anchor: ""
    result: pass|fail|not_run|unverified_review
    output_pointer: ""         # where the real output is retrievable, not a summary of it

conflicts:
  - id: ""
    between: []
    decision: ""
    decided_by: judge|anchor|human|unresolved
    rechecks: []

repairs:
  - finding: ""
    severity: blocker|major|minor
    owner: ""
    artifact: ""
    round: 0
    rechecks: []
    status: open|repaired|unresolved

run_log:                       # appended during the run; the evidence for every record-class criterion
  - at: "<round or wave>"
    event: ""
    detail: ""

limits:
  max_workers: "<positive integer>"
  max_concurrency: "<positive integer>"
  max_waves: "<positive integer>"
  max_retries: "<non-negative integer>"
  max_depth: "<positive integer>"
  time_limit: "<explicit duration>"
  budget:
    kind: worker_turns|tool_calls|tokens|cost|none
    value: "<positive number, or omitted when kind is none>"
    reason: "<required when kind is none: what this host cannot measure>"
  max_grader_rounds: "<positive integer>"

observed:                      # what actually happened; C8 compares these against limits
  workers: 0
  peak_concurrency: 0
  waves: 0
  retries: 0
  depth: 0
  elapsed: ""
  budget_used: "<value in budget.kind, or unmeasured>"
  grader_rounds: 0

approvals:
  graph: pending|approved|not_required
  commit: pending|approved|not_requested
  push: pending|approved|not_requested
  deploy: pending|approved|not_requested
  publish: pending|approved|not_requested
  delete: pending|approved|not_requested
  payment: pending|approved|not_requested
  external_send: pending|approved|not_requested

acceptance:
  grader: independent|self_graded
  round: 0
  score: "<passed>/<applicable>"
  gate: passed|blocked|capped|measured
  human_substitution:          # only when grader is self_graded; never converts a fail to a pass
    decided_by: ""
    shown: ""
  criteria:
    - id: ""
      verdict: pass|fail|not_applicable
      class: artifact|rerun|record
      severity: blocker|major|minor|none
      evidence: ""
      defect: ""
  unreachable: []              # criteria that cannot reach pass without a repair, named before the round
```

## Waves

A **wave** is one dispatch of a parallel group. A fan-out that runs once is one wave; a discovery
expansion that produces new units and dispatches them again is a second wave. `max_waves` caps how
many times the graph may expand and re-dispatch before it must stop and report what it has.

## Depth and nesting

A worker that owns a bounded subgraph may spawn nested workers up to `max_depth`. Nested workers
count against `max_workers` like any other — the cap is on the graph, not on one level of it. Set
`max_depth: 1` when no nesting is intended, and record `parent` and `depth` on every worker so
`observed.workers` and `observed.depth` can be checked against their caps.

## Worker failure and unusable output

A worker that fails, times out, returns nothing, or returns output that does not match its declared
output contract is `failed` or `unusable_output` with a `failure_reason`. It is never inferred to
have succeeded, and its intended artifact is never reported as produced. Retry it within
`max_retries`, route it to a different owner, or record the unit as not done — those are the three
options, and silently continuing as if the output arrived is not among them.

## Budget

`budget.kind` must name a unit this host can actually observe. A cap written in a unit the
runtime does not expose is not a cap; it is a number nobody enforces.

When no unit is observable, set `kind: none` with a `reason`, set `observed.budget_used` to
`unmeasured`, and say in the final report that the run had no enforceable budget. That is an honest
limitation. A fabricated token or cost figure is not.

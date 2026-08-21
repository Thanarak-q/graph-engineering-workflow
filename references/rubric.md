# Acceptance Rubric

The criteria a fresh grader scores. Fix them before the first round and never edit them mid-loop.
`SKILL.md` states the gate condition and the loop; this file holds the criteria themselves and the
evidence standard each one is held to.

## Gate condition

The graph is accepted only when every applicable criterion passes — `passed == applicable`. There is
no other route to `gate: passed` except the human substitution scoped below.

## Applicability

A **process** criterion (C1–C10) that the task does not exercise is marked `not_applicable` with a
one-line reason and leaves the denominator.

An **outcome** criterion (C11+) is never `not_applicable`. Outcome criteria are the user's own
requirements; a criterion that no longer applies is a scope change, which the user decides and
which is recorded as a rubric re-freeze with a new round-zero — never a verdict the grader may
return. `not_applicable` on an outcome criterion is a rubric edit wearing a verdict's clothes.

Every graph carries at least one outcome criterion. When the user confirmed no acceptance criteria
explicitly, derive one from the request, state it in the graph plan, and grade it. A score built
only from C1–C10 is never an acceptance: it is a well-run graph whose outcome is ungraded, and it
is reported as `gate: blocked` with the outcome ungraded, not as a pass.

## Evidence classes

Each criterion declares how its evidence can be checked, because they are not equally checkable.

| Class | The grader settles it by | Trust |
| :--- | :--- | :--- |
| `artifact` | Reading the final artifacts, the diff, or host state such as `git log`, branch and worktree history | Independent |
| `rerun` | Executing the anchor itself and reading the output | Independent |
| `record` | Reading the run log, because the fact exists nowhere else | Attested |

A `record`-class criterion is the weak seam in this rubric. It is the only kind the grader cannot
check for itself, so it is graded against the builder's own account of the run — the exact thing
every other rule here refuses to accept. Two constraints keep it honest:

1. **The run log is appended during the run, not composed after it.** Each entry carries the round
   or wave that produced it. A record-class criterion whose only evidence is a summary written after
   the work finished is `fail`, not `pass`.
2. **A record-class criterion may never be the sole basis for opening the gate.** If every outcome
   criterion is failing or ungraded, no arrangement of record-class passes accepts the graph.

Say in the final report which criteria were `record`-class, so the reader knows which part of the
score is attested rather than checked.

## Process criteria — fixed

| # | Criterion | Class | Passes only when |
| :--- | :--- | :--- | :--- |
| C1 | Topology is real | `record` | Independent units and real edges are documented, and every edge removed by the fake-edge test is named in `rejected_edges` with its reason. |
| C2 | Workers are bounded | `record` | Each worker has a stated input, output, owner, write boundary, verifier, and stop condition, and was handed the skills its node was assigned in the graph plan. |
| C3 | Writers are isolated | `artifact` | Every concurrent writer had a separate worktree, branch, container, or equivalent, evidenced from host state where the host records it and from the run log where it does not. |
| C4 | Research is traceable | `artifact` | Each claim carries source, evidence span, freshness, and confidence, the cited source resolves, and the claim passed fresh verification. |
| C5 | Audits are anchored | `artifact` | Each audit used a real anchor whose output is retrievable, or is recorded with `result: unverified_review` and labeled as such in the report. |
| C6 | Anchors actually ran | `rerun` | Tests, builds, scans, and type checks were executed, their output inspected, and the final artifact read back or run. Stored output that the grader cannot reproduce or retrieve does not satisfy this. |
| C7 | Conflicts and repairs are routed | `record` | Every conflict and repair has an owner, a decision or unresolved marker, and the rechecks that followed. |
| C8 | Limits held | `record` | Worker, concurrency, wave, retry, depth, and grader-round caps were set to explicit values, the observed count for each was recorded, every observed count is within its cap, and the budget either names an observable unit that held or is recorded as unenforceable with a reason. |
| C9 | Human gates held | `artifact` | No commit, push, deploy, publish, delete, payment, or external send happened without an explicit approval for that exact action, checked against host state where the host records it. |
| C10 | The report is honest | `artifact` | Facts, assumptions, decisions, and unresolved risks are separated, every anchor claimed in the report resolves to recorded output, and nothing is claimed that did not run. |

## Outcome criteria — one per acceptance criterion, from C11

- Derive them from `task.acceptance_criteria`, never from what the workers happened to build.
- Each passes only against a `rerun` anchor — a test, a run, an API call, an inspected output —
  never a worker's description of the behavior.
- Fix them before the first round along with C1–C10, and never add one mid-loop to justify work
  that was already done.
- They are never `not_applicable`, and there is always at least one.

A task with three acceptance criteria is graded out of thirteen, and a full score means 13/13.

## Read-only rounds

`SKILL.md` states the rule: one round, no repair, `gate: measured`. A round that fixes what it
measures is not the measurement that was asked for, and `blocked` would report a ceiling the user
set as a deficiency in the work. What that round owes the reader:

- the score, and every failing criterion with its severity and its evidence;
- state the round number and what changed since the previous score, so the snapshot can be
  re-taken as the work moves;
- say plainly that the loop was not run, so the score is a measurement rather than an acceptance;
- **name every criterion that cannot reach `pass` without a repair.** An outcome criterion that
  describes a defect is unreachable while writes are withheld, and a score capped by the request
  itself must not be reported as if the work fell short.

"Without changing anything" means the tracked source, artifacts, and history are left as they were.
Running an anchor is still allowed and still expected: a test run that touches a cache or a
coverage file is not a change to the work, so C6 stays reachable in a read-only round.

## Human substitution for the gate

An explicit human decision may stand in for an independent grader in exactly one case: the host
cannot give the grader a separate context, so `acceptance.grader` is `self_graded`. The human is
then deciding in place of the missing independence, not in place of a failing criterion.

A human decision never converts a failing criterion into a pass, never opens the gate while an
outcome criterion is failing, and is recorded with who decided and what they were shown.

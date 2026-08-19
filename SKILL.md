---
name: graph-engineering-workflow
description: Build and verify bounded agent graphs for coding work. Use when Codex or Claude needs to plan independent implementation, research, or audit work; coordinate isolated workers; verify results against evidence; merge changes; or route targeted repairs.
---

# Graph Engineering Workflow

## Purpose

Use this skill to turn a coding request into a task graph made of bounded agent loops, independent workers, fresh verifiers, evidence anchors, and explicit merge and repair rules. It is a graph-orchestration discipline, not a fixed implementation checklist and not a reason to spawn agents for every task.

The graph should make independent work wider, not make sequential work more complicated. A worker is allowed to contain its own loop: do the work, check it against a real anchor, repair it, and report an inspectable artifact.

## Task Routing

Use when the user asks to:

- implement a feature across independent files or components;
- fix or migrate many independent units;
- audit a repository, route set, module set, or data set;
- perform parallel research with evidence checking;
- run security, privacy, test, input, dependency, or code-quality audits;
- coordinate coding agents from Hermes, Codex, Claude Code, or another host.

Do not force this graph for a small, clear, single-file task or for work whose steps have real sequential dependencies. Use one agent loop when there is no meaningful fan-out.

## Operating Workflow

1. **Architect before fan-out.** Identify the units of work, their inputs and outputs, and the exact dependencies between them.
2. **Delete fake edges.** An edge exists only when downstream work must read upstream output. The phrase “then” is not evidence of a dependency.
3. **Fan out only independent work.** Parallelize files, modules, questions, or audit dimensions only when they can proceed without one another.
4. **Make each worker bounded.** Give it one job, a clear input, an output schema, an allowed write boundary, an anchor, and a stop condition.
5. **Do not trust worker self-reports.** A verifier uses a fresh context and checks source, tests, compiler output, scanner output, API behavior, or another real anchor.
6. **Keep research claims traceable.** Every important claim has a source pointer, evidence span or code location, freshness where relevant, and confidence.
7. **One owner merges.** Parallel workers do not jointly edit a shared artifact. A merge owner resolves conflicts and records the decision.
8. **Isolate writers.** Use separate worktrees, branches, containers, or equivalent boundaries when more than one worker writes code.
9. **Route repairs narrowly.** A failed audit returns the affected artifact to the responsible worker and reruns only the impacted checks plus required regression checks.
10. **Cap the graph.** Before dispatching any non-trivial graph, set explicit limits for worker count, concurrency, waves, retries, grader rounds, time, and budget. Unset or zero-valued limits are not valid defaults. Scale only after a small pilot is inspectable.
11. **Gate irreversible actions.** Commit, push, deploy, publish, delete, payment, and external sends require an explicit human gate unless the user has already granted a clear equivalent approval for that exact action.
12. **Report evidence, not confidence.** Never call work complete because a worker says it is complete.
13. **Close on a graded rubric.** Fix the acceptance criteria before the work starts, and let a fresh grader score them against evidence. The graph closes on a full score, not on the builder's judgment that it is done. In `score-only` mode the grader measures and stops; it never repairs what it is grading.

## User Interaction

When a request is ambiguous, ask one high-value question at a time before writing code. Do not ask a generic “what is the pain point?” for a precise coding request; ask about the missing behavior, scope, constraint, or success condition.

Use choices when the decision has a bounded set of answers and allow a free-text alternative:

- offer no more than four useful choices;
- include `Other (type your answer)` when appropriate;
- let the user correct the choice;
- do not hide a meaningful trade-off inside a default.

On Hermes, use the native `clarify` tool when available. On Codex or Claude Code, present a short numbered choice list and accept a typed answer.

After clarification, state the confirmed objective, scope, acceptance criteria, constraints, and unresolved questions. If the request is clear and low-risk, a concise confirmation is enough. For a multi-writer, sensitive, or high-impact graph, show the graph plan and wait for approval before implementation.

## Skill Discovery and Routing

Run a short, read-only **Skill Discovery** for every request before selecting the graph. Inspect the skills available in the current environment and match them to the request, the repository context, and candidate nodes. For a small task, keep this to a quick inventory and only record a selected skill when one materially helps.

Use two layers of routing:

1. **Known routing map:** Match a node to a known companion skill when one is available: `grilling` for a user-requested or high-trade-off decision; `to-spec` or `domain-modeling` for requirements and domain design; `codebase-design` for codebase investigation and architecture; `research` for external research; `implement` or `tdd` for implementation and verification; `code-review` for code-quality audit; `devsecops` for security, privacy, or dependency audit; `diagnosing-bugs` for repair; `resolving-merge-conflicts` for merge; `handoff` for a final transfer; and `prototype` or `improve-codebase-architecture` when their specific purpose applies.
2. **Description-based routing:** Also consider any available skill whose description is more specific to the language, framework, artifact, domain, tool, or risk than the known map.

Graph Engineering Workflow controls topology, ownership, isolation, limits, merge, repair, and reporting. A selected skill controls its domain workflow only; it must not expand the graph, override limits, or bypass human gates.

Choose skills for their expected value, not because they match a keyword. Multiple skills may be selected when their responsibilities do not overlap. When they overlap, select the more specific or safer skill and record why the other was skipped. Pass a worker only the skills selected for that node, with its task boundary and reason for selection.

A worker uses the skills it was handed and does not go shopping for more. Its own environment may list skills the parent did not select; that listing is not a mandate, and a worker that decides it needs another skill reports the gap in its output instead of expanding its own scope. The parent owns routing because only the parent can see the whole graph.

Route the acceptance grader like any other node. It may use a read-only review or audit skill that helps it check a criterion, and it may never use a skill that writes, repairs, or otherwise changes what it is grading.

Skill Discovery runs before the graph is selected, so its first pass is an inventory, not a final assignment. Bind skills to nodes once the units exist, and record any skill added later with the round or node that introduced it.

If a selected skill is unavailable at execution time or conflicts with the task constraints, continue with the base workflow and record it as skipped. Do not install, request installation of, or block on an optional companion skill during a graph run. The README may recommend companion skills for future installation.

## Graph Construction

### 1. Codebase Investigator (read-only)

For non-trivial repository work, run a **Codebase Investigator** before the Graph Architect and before any external research. It maps the project context that the graph needs:

- repository and directory rules;
- relevant files and existing patterns;
- current tests and verification commands;
- interfaces, schemas, dependencies, and ownership boundaries;
- current diff and worktree state when relevant.

Its output is a compact repository map, candidate work units, known ownership conflicts, and unknowns that may justify external research. Do not inspect populated secret files. Do not modify files during discovery.

For a task without a repository, replace this node with the smallest read-only context discovery that can identify work units and dependencies.

### 2. Define work units

Write each unit as a concrete job, not a vague persona. Examples:

- inspect one route file for missing authorization;
- compare one API option against official documentation;
- implement the backend slice owned by `src/auth/`;
- run input and boundary tests for one parser;
- review a specific diff for privacy leakage.

Every unit must declare:

- input;
- output artifact or finding;
- evidence required;
- write boundary;
- owner;
- verifier;
- selected skills for this node, each with the reason it was chosen;
- retry and stop condition.

### 3. Apply the fake-edge test

For every proposed edge, answer:

> What exact output crosses this edge, and does the downstream job fail or become materially different without it?

Keep the edge only when the answer is concrete. If two jobs can start from the same state and do not write the same artifact, place them in the same parallel group.

### 4. Select topology

Choose the smallest topology that does the work:

- **single loop:** one worker owns a sequential task;
- **fan-out/fan-in:** independent workers run, then one owner aggregates;
- **conditional route:** a finding or score chooses the next path;
- **repair loop:** a failed anchor returns work to a bounded worker;
- **discovery expansion:** finders produce new units until the stop condition is met;
- **audit fan-out:** independent audit dimensions inspect the same integrated artifact;
- **hierarchical graph:** a bounded subgraph owns one larger area.

A single loop is valid. A graph is justified by real width, independent verification, or a meaningful route—not by the number of boxes in a diagram.

## Canonical Shape for Coding Work

```text
User request
  -> Skill Discovery (read-only)
  -> clarify if needed
  -> Codebase Investigator (read-only, for repository work)
  -> graph architect + fake-edge test
  -> optional external research fan-out where unresolved unknowns are independent
  -> fresh evidence verification
  -> one research merge owner
  -> implementation fan-out where code ownership is independent
  -> per-worker implementation loop and local anchors
  -> isolated merge/integration
  -> selected audit fan-out
  -> audit merge and conflict decision
  -> narrow repair route
  -> final verification and report
  -> acceptance gate (fresh grader scores the rubric; failures route back)
  -> human gate before commit/push/deploy
```

This is a capability map, not a mandatory sequence for every task. The Codebase Investigator is the read-only front door for non-trivial repository work. External research, implementation branches, audits, and even the graph itself are optional: remove any node or edge that the actual task does not justify.

## External Research Graph

Add external research only when the Codebase Investigator identifies an unresolved question that the repository cannot answer. Typical workers include requirements/API research, dependency research, regulatory or policy research, and security research against external guidance.

Do not merge worker summaries just because they agree. A fresh research verifier must inspect the cited source or code and check:

- whether the evidence supports the claim;
- whether the claim exceeds the evidence;
- whether sources conflict or are stale;
- whether identifiers, versions, and assumptions match;
- whether the worker invented an uncited capability or result.

When findings conflict, preserve both claims and provenance, then route them to a conflict judge or a human decision. The merge owner must not silently choose one.

A good research output looks like:

```yaml
claim: "..."
source: "path, URL, document ID, or code location"
evidence: "quoted span, command output, or exact symbol"
freshness: "known date or unknown"
confidence: 0.0
status: verified|rejected|conflict|needs-human-decision
```

## Implementation Graph

Split implementation only along real ownership boundaries. Examples are backend, frontend, migration, documentation, or test work when each can proceed without editing the same artifact.

Each implementation worker must:

1. receive a bounded task, its acceptance checks, and the skills selected for its node with the reason for each;
2. work in an isolated worktree, branch, container, or equivalent boundary when another worker writes concurrently;
3. avoid modifying artifacts owned by another worker;
4. run local anchors such as targeted tests, type checks, builds, or linters;
5. return changed paths, commands run, real results, and unresolved issues.

Do not report a successful implementation from a worker's prose alone. Read the diff and inspect the command results.

## Audit Graph

After integration, select audit nodes based on the change and its risk. Do not run every audit by habit.

Possible audit workers:

- **security:** authentication, authorization, injection, secrets, unsafe defaults, deserialization, dependency risk;
- **privacy:** PII, logging, data exposure, retention, access boundaries, telemetry, and data flow;
- **functional:** acceptance criteria and expected behavior;
- **input/edge:** empty, malformed, boundary, oversized, unexpected, and adversarial input;
- **regression:** behavior outside the changed area;
- **code quality:** error handling, duplication, complexity, maintainability, type safety, and unintended diff;
- **dependency/SCA:** versions, vulnerabilities, licenses, and lockfile integrity.

Prefer deterministic anchors:

- actual test commands and their output;
- compiler, type checker, and linter output;
- security or dependency scanner output;
- an API call or integration check;
- a direct code/data-flow inspection with exact locations;
- immutable policy or acceptance rules.

An audit worker may explain a risk, but “looks safe” is not a security result and “tests should pass” is not a test result.

## Repair and Conflict Routing

The audit merge produces findings with severity, evidence, affected artifact, owner, and required rechecks. The repair router sends each finding to the responsible worker. It must not restart unrelated workers without a dependency reason.

Example:

```text
privacy audit: sensitive value written to debug log
  -> route to logging owner
  -> rerun privacy audit
  -> rerun affected functional/regression tests
```

If audits disagree, do not average the opinions. Route the conflict to an independent judge, a deterministic anchor, or a human gate. Record the unresolved state if no authority can decide it.

## State and Artifact Contract

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
  budget: "<explicit token or cost limit>"
  max_grader_rounds: "<positive integer>"
approvals:
  graph: pending|approved|not_required
  commit: pending|approved|not_requested
  push: pending|approved|not_requested
  deploy: pending|approved|not_requested

acceptance:
  mode: hybrid|score-only
  grader: independent|self_graded
  round: 0
  score: "<passed>/<applicable>"
  gate: open|closed|capped
  criteria:
    - id: ""
      verdict: pass|fail|not_applicable
      severity: blocker|major|minor|none
      evidence: ""
      defect: ""
```

## Cross-Provider Use

Use the host's native execution mechanism, but keep the graph contract unchanged:

- **Hermes:** use `delegate_task` for bounded isolated workers when appropriate; use native `clarify` for choices; keep one parent merge owner; verify returned artifacts yourself.
- **Codex:** use native subagents or separate bounded `codex` executions when available; use isolated worktrees for concurrent writers; otherwise run the graph sequentially rather than pretending it was parallel.
- **Claude Code:** use native subagents, teams, or isolated worktrees when available; keep verifier context separate from executor context; collect structured reports before merging.

Get the acceptance grader a genuinely separate context on whatever host you are on: a fresh delegated task on Hermes, a separate subagent or `codex` execution on Codex, a subagent or worktree-scoped session on Claude Code. Hand it the rubric, the artifacts, the diff, and the recorded evidence — never the build transcript.

When the host cannot give you an independent context at all, still grade the rubric, but record the result as `self_graded` and say so in the report. A self-graded score is a measurement the builder took of its own work; it never closes the acceptance gate on its own, and it needs a human decision in place of the gate.

A platform limitation is not permission to claim that a worker ran, a verifier checked something, or parallelism occurred. Report what actually executed.

## Graph Plan Output

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
Limits: explicit numeric worker/concurrency/wave/retry/grader-round caps plus time and budget
Human gates: ...
```

Ask for user approval when the graph has material scope, cost, security, privacy, data-loss, or multi-writer trade-offs. Do not ask for approval merely to run a read-only inspection the user already requested.

## Acceptance Rubric

The graph is complete when a fresh grader scores **10/10** on the rubric below. The score is not an impression: it is the count of criteria that passed out of the criteria that apply. Each criterion is binary and must be answered with an evidence pointer — a `file:line`, a command and its output, or an artifact id. A criterion that the task does not exercise is marked `not_applicable` with a one-line reason and is excluded from the denominator, so a small graph may legitimately close at 7/7.

| # | Criterion | Passes only when |
|---|---|---|
| C1 | Topology is real | Independent units and real edges are documented, and every removed fake edge is named. |
| C2 | Workers are bounded | Each worker has a stated input, output, owner, write boundary, and stop condition, and was handed the skills its node was assigned in the graph plan. |
| C3 | Writers are isolated | Every concurrent writer had a separate worktree, branch, container, or equivalent. |
| C4 | Research is traceable | Each claim carries source, evidence span, freshness, and confidence, and passed fresh verification. |
| C5 | Audits are anchored | Each audit used a real anchor, or is explicitly labeled an unverified review. |
| C6 | Anchors actually ran | Tests, builds, scans, and type checks were executed, their output inspected, and the final artifact read back or run. |
| C7 | Conflicts and repairs are routed | Every conflict and repair has an owner, a decision or unresolved marker, and the rechecks that followed. |
| C8 | Limits held | Worker, concurrency, wave, retry, time, budget, and grader-round caps were set to explicit values and respected. |
| C9 | Human gates held | No commit, push, deploy, publish, delete, payment, or external send happened without an explicit approval for that exact action. |
| C10 | The report is honest | Facts, assumptions, decisions, and unresolved risks are separated, and nothing is claimed that did not run. |

Criteria C1–C10 grade how the graph was run. They do not grade whether the work is correct, and a graph that follows every rule while shipping the wrong behavior can still pass all ten. So the rubric also carries one **outcome criterion per acceptance criterion** confirmed with the user, numbered from C11:

- derive them from `task.acceptance_criteria`, not from what the workers happened to build;
- each one passes only against a real anchor — a test, a run, an API call, an inspected output — never a worker's description of the behavior;
- fix them before the first round along with C1–C10, and never add one mid-loop to justify work that was already done.

A task with three acceptance criteria is graded out of thirteen. `10/10` on the process criteria alone is not a passing graph; it is a well-run graph whose outcome is still ungraded.

## Grading Modes

The rubric runs in one of two modes. **`hybrid` is the default**; use it unless the user names another mode.

| Mode | Grader | Repair | Writes | Ends when |
|---|---|---|---|---|
| `hybrid` (default) | Scores the rubric and returns a defect list | Routes every failure to its owner and re-grades | Yes | Full score, or `max_grader_rounds` is reached |
| `score-only` | Scores the rubric and returns a defect list | None | No | The user says so, or there is nothing new to grade |

Enter `score-only` when the user asks for it by name, or asks to grade, score, audit, or review without changing anything. In this mode:

- do not edit, repair, commit, or run anything that writes — the mode is read-only, and its value comes from being an untouched measurement;
- report the score, every failing criterion, its severity, and its evidence, then stop and hand the decision to the user;
- keep grading rounds cheap and repeatable so the score can be re-taken as the work moves, and state the round number and what changed since the previous score;
- never repair a defect just because it is small. A grader that fixes what it measures is no longer an independent measurement, and its next score is worthless.

`score-only` does not close the graph. A passing score from it is a measurement, not an acceptance; the work still needs a `hybrid` gate or an explicit human decision before it counts as complete.

Announce the active mode in the graph plan and in the final report. If the user asks for repairs while in `score-only`, switch to `hybrid` and say that the mode changed.

## Fresh Grader Loop

The grader is a node in the graph, not a formality at the end.

1. **Grade with a fresh context.** The grader receives the rubric, the final artifacts, the diff, and the recorded evidence — never the build conversation. A grader that watched the work is not an independent check, and reusing the builder's context is the fastest way to a fake 10/10.
2. **Return a defect list, not a verdict.** Every `fail` carries the criterion id, the evidence that shows the failure, a severity of `blocker`, `major`, or `minor`, and the specific defect. `major` and `minor` set repair order; only the pass/fail state decides whether the gate opens.
3. **Route failures narrowly.** Each defect goes to the responsible worker through the existing repair router, not back through the whole graph.
4. **Re-grade the whole rubric.** The next round re-checks every criterion, not only the repaired ones, so a fix cannot silently break a criterion that already passed.
5. **Never edit the rubric mid-loop.** The criteria are fixed before the first round. If a criterion turns out to be wrong, stop the loop, say so, and get the user's decision — do not soften the criterion to make the score rise.
6. **Stop at the cap.** (`hybrid` only.) The loop ends at `10/10` or at `max_grader_rounds`. Hitting the cap with criteria still failing is a capped result, not a completed one; report the score, the open defects, and what remains.

```text
build -> fresh grader -> 10/10? -> yes -> human gate
                           |
                           no -> defect list -> narrow repair -> re-grade (round + 1)
```

A grader round returns exactly this shape:

```yaml
mode: hybrid
round: 2
score: "11/13"
gate: closed
criteria:
  - id: C6
    verdict: pass
    severity: none
    evidence: "pnpm test -- auth/: 48 passed, 0 failed"
  - id: C4
    verdict: not_applicable
    severity: none
    evidence: "no external research node ran"
  - id: C11
    verdict: fail
    severity: blocker
    evidence: "POST /login with a valid password returns 500; src/auth/session.ts:74"
    defect: "session write happens before the transaction commits"
  - id: C9
    verdict: fail
    severity: major
    evidence: "git log shows commit 4a1c2f9 with approvals.commit still pending"
    defect: "committed without the human gate"
```

For a small single-loop task, this collapses to one grading pass over a short rubric. Do not spawn a grader graph for work that a single fresh read can settle.

## Default Response Shape

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

## Pitfalls

- Treating a linear checklist as a graph.
- Adding an edge because the prose says “then.”
- Spawning one worker per stage instead of one worker per independent unit.
- Giving every worker the full shared conversation and calling the result independent.
- Letting workers edit the same workspace or artifact without isolation.
- Merging conflicting research without provenance or a judge.
- Running an audit that has no anchor and reporting an opinion as verification.
- Running every audit for every change.
- Scaling before measuring cost, failure rate, and merge quality.
- Using a role name as a security boundary.
- Letting an optimizer change the metric, policy, or acceptance rule it is being judged against.
- Treating a worker's self-report as proof that an artifact exists.
- Giving the acceptance grader the build conversation and still calling it a fresh grader.
- Rewriting, softening, or dropping a rubric criterion during the loop instead of fixing the work.
- Reporting a rubric score without the evidence pointer that earned each pass.
- Declaring completion after the grader round cap when criteria are still failing.

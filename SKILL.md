---
name: graph-engineering-workflow
description: >
  Plan and verify bounded agent graphs for complex coding work. Use when a
  coding agent needs to coordinate independent implementation, research,
  verification, auditing, isolated writers, merge ownership, or targeted
  repair loops. Prefer a single loop for small or genuinely sequential tasks.
license: MIT
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

## Operating Principles

These thirteen rules are the summary layer. Each names the section that specifies it, and that section is normative — when this list and a section appear to disagree, the section wins.

1. **Architect before fan-out.** Identify the units of work, their inputs and outputs, and the exact dependencies between them. → *Graph Construction*
2. **Delete fake edges.** An edge exists only when downstream work must read upstream output. → *Apply the fake-edge test*
3. **Fan out only independent work.** → *Select topology*
4. **Make each worker bounded.** One job, one input, one output schema, one write boundary, an anchor, a stop condition. → *Define work units*
5. **Do not trust worker self-reports.** A verifier works from a fresh context and a real anchor. → *Audit Graph*
6. **Keep research claims traceable.** → *External Research Graph*
7. **One owner merges.** Parallel workers never jointly edit a shared artifact. → *Implementation Graph*
8. **Isolate writers.** → *Implementation Graph*
9. **Route repairs narrowly.** → *Repair and Conflict Routing*
10. **Cap the graph.** Unset or zero-valued limits are not valid defaults, and the budget must name a unit this host can actually observe. → *State and Artifact Contract*
11. **Gate irreversible actions.** Commit, push, deploy, publish, delete, payment, and external sends need an explicit human gate. → *Graph Plan Output*
12. **Report evidence, not confidence.** Never call work complete because a worker says it is complete. → *Default Response Shape*
13. **Close on a graded rubric.** Fix the criteria before the work starts; a fresh grader scores them against evidence. → *Acceptance Rubric*, *Fresh Grader Loop*

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

Run a short, read-only **Skill Discovery** before selecting the graph for any non-trivial request. Inspect the skills available in the current environment and match them to the request, the repository context, and candidate nodes. Skip it for work small enough that no companion skill would change the approach; a single-file fix does not need a routing pass.

Use two layers of routing:

1. **Known routing map:** Match a node to a known companion skill using [references/skill-routing.md](references/skill-routing.md).
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

## External Research Graph

Add external research only when the Codebase Investigator identifies an unresolved question that the repository cannot answer. Typical workers include requirements/API research, dependency research, regulatory or policy research, and security research against external guidance.

Do not merge worker summaries just because they agree. A fresh research verifier must inspect the cited source or code and check:

- whether the evidence supports the claim;
- whether the claim exceeds the evidence;
- whether sources conflict or are stale;
- whether identifiers, versions, and assumptions match;
- whether the worker invented an uncited capability or result.

When findings conflict, preserve both claims and provenance, then route them to a conflict judge or a human decision. The merge owner must not silently choose one.

Each claim is returned in the fixed shape in [references/research-output.md](references/research-output.md).

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

Read [references/state-contract.md](references/state-contract.md) for the full state schema before
dispatching a non-trivial graph, and again when recording limits, approvals, or acceptance results.

## Cross-Provider Use

Use the host's native execution mechanism, but keep the graph contract unchanged. A platform
limitation is not permission to claim that a worker ran, a verifier checked something, or
parallelism occurred. Report what actually executed.

Read [references/hosts.md](references/hosts.md) for per-host execution, isolation, and grader
guidance before dispatching workers on a host you have not used in this session.

## Graph Plan Output

Before executing a non-trivial graph, show a compact plan and ask for approval when the graph has
material scope, cost, security, privacy, data-loss, or multi-writer trade-offs. Do not ask for
approval merely to run a read-only inspection the user already requested.

Read [references/output-contracts.md](references/output-contracts.md) for the plan template.

## Acceptance Rubric

The graph is accepted only when a fresh grader passes **every applicable criterion** — `passed == applicable` — or when an explicit human decision substitutes for an independent gate where that is allowed. The score is not an impression: it is the count of criteria that passed out of the criteria that apply. Each criterion is binary and must be answered with an evidence pointer — a `file:line`, a command and its output, or an artifact id. A criterion that the task does not exercise is marked `not_applicable` with a one-line reason and is excluded from the denominator, so a small graph may legitimately be accepted at 7/7.

| # | Criterion | Passes only when |
|---|---|---|
| C1 | Topology is real | Independent units and real edges are documented, and every removed fake edge is named. |
| C2 | Workers are bounded | Each worker has a stated input, output, owner, write boundary, and stop condition, and was handed the skills its node was assigned in the graph plan. |
| C3 | Writers are isolated | Every concurrent writer had a separate worktree, branch, container, or equivalent. |
| C4 | Research is traceable | Each claim carries source, evidence span, freshness, and confidence, and passed fresh verification. |
| C5 | Audits are anchored | Each audit used a real anchor, or is explicitly labeled an unverified review. |
| C6 | Anchors actually ran | Tests, builds, scans, and type checks were executed, their output inspected, and the final artifact read back or run. |
| C7 | Conflicts and repairs are routed | Every conflict and repair has an owner, a decision or unresolved marker, and the rechecks that followed. |
| C8 | Limits held | Worker, concurrency, wave, retry, time, and grader-round caps were set to explicit values and respected, and the budget either names an observable unit that held or is recorded as unenforceable with a reason. |
| C9 | Human gates held | No commit, push, deploy, publish, delete, payment, or external send happened without an explicit approval for that exact action. |
| C10 | The report is honest | Facts, assumptions, decisions, and unresolved risks are separated, and nothing is claimed that did not run. |

Criteria C1–C10 grade how the graph was run. They do not grade whether the work is correct, and a graph that follows every rule while shipping the wrong behavior can still pass all ten. So the rubric also carries one **outcome criterion per acceptance criterion** confirmed with the user, numbered from C11:

- derive them from `task.acceptance_criteria`, not from what the workers happened to build;
- each one passes only against a real anchor — a test, a run, an API call, an inspected output — never a worker's description of the behavior;
- fix them before the first round along with C1–C10, and never add one mid-loop to justify work that was already done.

A task with three acceptance criteria is graded out of thirteen, and a full score means 13/13. Passing all ten process criteria is not a passing graph on its own; it is a well-run graph whose outcome is still ungraded.

## Grading Modes

The rubric runs one way: a fresh grader scores it, every failure routes to its owner, and the next round re-grades everything. The loop is not optional and has no variant that grades without repairing. The independence that makes a score trustworthy comes from context isolation and ownership routing, not from banning repair — the grader never repairs anything in any case. Defects go to the repair router, the router sends each one to the worker that owns the artifact, and the next round is scored by a fresh grader again.

A read-only score is still available, as a request rather than a named mode. When the user asks to grade, score, audit, or review **without changing anything**:

- run exactly one round and stop;
- report the score, every failing criterion, its severity, and its evidence, then hand the decision to the user;
- state the round number and what changed since the previous score, so the snapshot can be re-taken as the work moves;
- say plainly that the loop was not run, so the score is a measurement rather than an acceptance;
- **name every criterion that cannot reach `pass` without a repair.** An outcome criterion that describes a defect is unreachable while writes are withheld, and a score capped by the request itself must not be reported as if the work fell short.

Do not repair a defect during a read-only round, however small — a round that fixes what it measures is not the measurement the user asked for. If the user then asks for repairs, run the loop and say that it started.

Say in the graph plan whether the loop will run, and say the same in the final report.

## Fresh Grader Loop

The grader is a node in the graph, not a formality at the end.

1. **Grade with a fresh context.** The grader receives the rubric, the final artifacts, the diff, and the recorded evidence — never the build conversation. A grader that watched the work is not an independent check, and reusing the builder's context is the fastest way to a fake pass.
2. **Return a defect list, not a verdict.** Every `fail` carries the criterion id, the evidence that shows the failure, a severity of `blocker`, `major`, or `minor`, and the specific defect. `major` and `minor` set repair order; only the pass/fail state decides whether the gate opens.
3. **Route failures narrowly.** Each defect goes to the responsible worker through the existing repair router, not back through the whole graph.
4. **Re-grade the whole rubric.** The next round re-checks every criterion, not only the repaired ones, so a fix cannot silently break a criterion that already passed.
5. **Never edit the rubric mid-loop.** The criteria are fixed before the first round. If a criterion turns out to be wrong, stop the loop, say so, and get the user's decision — do not soften the criterion to make the score rise.
6. **Stop at the cap.** The loop ends at a full applicable score or at `max_grader_rounds`. Hitting the cap with criteria still failing is a capped result, not a completed one; report the score, the open defects, and what remains.

```text
build -> fresh grader -> full score? -> yes -> human gate
                           |
                           no -> defect list -> narrow repair -> re-grade (round + 1)
```

The round's output shape is fixed: see [references/grader-output.md](references/grader-output.md).

For a small single-loop task, this collapses to one grading pass over a short rubric. Do not spawn a grader graph for work that a single fresh read can settle.

## Default Response Shape

Report one consolidated result, not a transcript from every worker. Never fabricate worker output,
test results, scan results, URLs, commits, or successful external actions.

Read [references/output-contracts.md](references/output-contracts.md) for the required report contents.

## Pitfalls

The common failure modes — fake edges, unisolated writers, anchorless audits, self-graded
acceptance, and treating a self-report as proof — are catalogued in
[references/pitfalls.md](references/pitfalls.md). Read it when a graph feels wrong but no rule has
obviously been broken.

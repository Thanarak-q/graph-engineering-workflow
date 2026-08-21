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

Turn a coding request into a task graph of bounded agent loops, independent workers, fresh verifiers, evidence anchors, and explicit merge and repair rules. This is a graph-orchestration discipline, not a fixed checklist and not a reason to spawn agents for every task.

The graph should make independent work wider, not make sequential work more complicated. A worker may contain its own loop: do the work, check it against a real anchor, repair it, and report an inspectable artifact.

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

These fourteen rules are the summary layer. Each names the section that specifies it, and that section is normative — when this list and a section appear to disagree, the section wins.

1. **Architect before fan-out.** Identify the units of work, their inputs and outputs, and the exact dependencies between them. → *Graph Construction*
2. **Delete fake edges.** An edge exists only when downstream work must read upstream output. → *Apply the fake-edge test*
3. **Fan out only independent work.** → *Select topology*
4. **Make each worker bounded.** One job, one input, one output schema, one write boundary, an anchor, a stop condition. → *Define work units*
5. **Do not trust worker self-reports.** A verifier works from a fresh context and a real anchor. → *Audit Graph*
6. **Keep research claims traceable.** → *External Research Graph*
7. **One owner merges.** Parallel workers never jointly edit a shared artifact. → *Implementation Graph*
8. **Isolate writers.** → *Implementation Graph*
9. **Route repairs narrowly.** → *Repair and Conflict Routing*
10. **Cap the graph.** Unset or zero-valued limits are not valid defaults, the budget must name a unit this host can actually observe, and every cap needs a recorded observed count or it cannot be said to have held. → *State and Artifact Contract*
11. **Gate irreversible actions.** Commit, push, deploy, publish, delete, payment, and external sends each need an explicit human approval for that exact action, granted after the change exists. A stated intent up front is not an approval. → *Graph Plan Output*
12. **Report evidence, not confidence.** Never call work complete because a worker says it is complete, and report on every outcome — including a capped or abandoned run. → *Default Response Shape*
13. **Close on a graded rubric.** Fix the criteria before the work starts; a fresh grader scores them against evidence. Every graph carries at least one outcome criterion. → *Acceptance Rubric*, *Fresh Grader Loop*
14. **Never infer a worker's success.** A worker that fails, returns nothing, or breaks its output contract has not done its unit. → *Define work units*

## User Interaction

When a request is ambiguous, ask one high-value question at a time before writing code. Do not ask a generic “what is the pain point?” for a precise coding request; ask about the missing behavior, scope, constraint, or success condition.

Use choices when the decision has a bounded set of answers and allow a free-text alternative:

- offer no more than four useful choices;
- include `Other (type your answer)` when appropriate;
- let the user correct the choice;
- do not hide a meaningful trade-off inside a default.

Use the host's native choice mechanism where it has one, and a short numbered list otherwise.

After clarification, state the confirmed objective, scope, acceptance criteria, constraints, and unresolved questions. The acceptance criteria are what the outcome criteria C11+ are derived from, so confirm at least one even when the request is clear. If the request is clear and low-risk, a concise confirmation is enough. For a multi-writer, sensitive, or high-impact graph, show the graph plan and wait for approval before implementation.

## Skill Discovery and Routing

Run a short, read-only **Skill Discovery** before selecting the graph for any non-trivial request. Inspect the skills available in the current environment and match them to the request, the repository context, and candidate nodes. Skip it for work small enough that no companion skill would change the approach; a single-file fix does not need a routing pass.

Where the host exposes no skill inventory, do not guess at names and do not claim a routing pass happened. Record the discovery as skipped with that reason and run the base workflow.

Route in two layers: match a node to a known companion skill, then consider any available skill whose description is more specific to the language, framework, artifact, domain, tool, or risk than the known map.

This skill controls topology, ownership, isolation, limits, merge, repair, and reporting. A selected skill controls its domain workflow only. Pass a worker only the skills selected for that node, with its task boundary and the reason each was chosen; a worker uses what it was handed and reports a gap rather than shopping for more. A missing companion skill is recorded as skipped and never blocks the run.

Read [references/skill-routing.md](references/skill-routing.md) for the routing map and the full rules on worker scope, grader routing, and unavailable skills.

## Graph Construction

### 1. Codebase Investigator (read-only)

For non-trivial repository work, run a **Codebase Investigator** before the Graph Architect and before any external research. It maps repository and directory rules, relevant files and existing patterns, current tests and verification commands, interfaces, schemas, dependencies, ownership boundaries, and the current diff and worktree state where relevant.

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

These are the fields C2 grades, so they live in the run record rather than only in the dispatch prompt.

**A worker's result is not assumed.** A worker that fails, times out, returns nothing, or returns output that does not match its declared output contract is recorded as `failed` or `unusable_output` with a reason. Retry it within `max_retries`, route the unit to another owner, or record the unit as not done. Continuing as if the output arrived — or describing its intended artifact as produced — is the failure this rule exists to stop.

**Nested workers are still workers.** A worker owning a bounded subgraph may spawn its own workers up to `max_depth`, and every one of them counts against `max_workers`. The cap is on the graph, not on one level of it.

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
- **discovery expansion:** finders produce new units until the stop condition is met, each dispatch counting as one **wave** against `max_waves`;
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

After integration, select audit nodes based on the change and its risk. Do not run every audit by habit, and prefer a deterministic anchor over an opinion in every case.

An audit worker may explain a risk, but “looks safe” is not a security result and “tests should pass” is not a test result. An audit that reached no anchor is recorded with `result: unverified_review` and labeled that way in the report — the escape hatch is honest labeling, not silence, and never an invented scanner output.

Read [references/audits.md](references/audits.md) for the audit dimensions and the anchors to prefer.

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

Two properties of that state are normative wherever it is kept. Limits are explicit positive values, each with an observed count recorded against it. And the run log is **appended during the run**, not composed after it — the acceptance grader reads it instead of the build transcript, so a record written afterward is an account of the work rather than evidence of it.

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

The plan names every irreversible action the graph could reach — commit, push, deploy, publish,
delete, payment, external send — and each one still needs its own approval at the moment it is
reached, once the change exists and can be inspected.

Read [references/output-contracts.md](references/output-contracts.md) for the plan template.

## Acceptance Rubric

The graph is accepted only when a fresh grader passes **every applicable criterion** — `passed == applicable`. The score is not an impression: it is the count of criteria that passed out of the criteria that apply. Each criterion is binary and must be answered with an evidence pointer — a `file:line`, a command and its output, or an artifact id.

**C1–C10 grade how the graph was run** — topology, bounded workers, isolated writers, traceable research, anchored audits, anchors that ran, routed conflicts and repairs, limits, human gates, an honest report. They do not grade whether the work is correct, and a graph that follows every rule while shipping the wrong behavior passes all ten.

**C11 upward grade the outcome**, one criterion per acceptance criterion confirmed with the user, derived from `task.acceptance_criteria` and never from what the workers happened to build. **Every graph carries at least one.** Where the user confirmed none explicitly, derive one from the request, state it in the graph plan, and grade it. A score built from C1–C10 alone is never an acceptance; it is a well-run graph whose outcome is ungraded, and it reports as `blocked`.

A process criterion the task does not exercise is marked `not_applicable` with a one-line reason and leaves the denominator, so a small graph may legitimately be accepted at 8/8. **An outcome criterion is never `not_applicable`** — dropping the user's own requirement out of the denominator is a rubric edit wearing a verdict's clothes. A requirement that genuinely stopped applying is a scope change the user decides.

Criteria are not equally checkable, so each declares an evidence class: `artifact` and `rerun` the grader settles for itself, `record` it can only read from the run log. Record-class criteria are graded against the builder's own account — which is why the log is appended during the run, and why no arrangement of record-class passes opens the gate while an outcome criterion is failing.

Read [references/rubric.md](references/rubric.md) for the ten process criteria, their pass conditions and evidence classes, the outcome-criterion rules, and the one case in which a human decision may stand in for an independent grader.

## The Grading Loop

The rubric runs one way: a fresh grader scores it, every failure routes to its owner, and the next round re-grades everything. The loop is not optional and has no variant that grades without repairing. Independence comes from context isolation and ownership routing, not from banning repair — the grader never repairs anything in any case.

A read-only score is still available, as a request rather than a named mode. When the user asks to grade, score, audit, or review **without changing anything**:

- run exactly one round and stop;
- record `gate: measured`, not `blocked` — no gate decision was taken, because none was asked for;
- report the score, every failing criterion, its severity, and its evidence, then hand the decision to the user;
- state the round number and what changed since the previous score, so the snapshot can be re-taken as the work moves;
- say plainly that the loop was not run, so the score is a measurement rather than an acceptance;
- **name every criterion that cannot reach `pass` without a repair.** An outcome criterion that describes a defect is unreachable while writes are withheld, and a score capped by the request itself must not be reported as if the work fell short.

"Without changing anything" means the tracked source, artifacts, and history are left as they were. Running an anchor is still allowed and still expected — a test run that touches a cache or a coverage file is not a change to the work, and C6 stays reachable in a read-only round. What a read-only round may not do is repair.

Do not repair a defect during a read-only round, however small — a round that fixes what it measures is not the measurement the user asked for. If the user then asks for repairs, run the loop and say that it started.

Say in the graph plan whether the loop will run, and say the same in the final report.

## Fresh Grader Loop

The grader is a node in the graph, not a formality at the end.

1. **Grade with a fresh context.** The grader receives the rubric, the final artifacts, the diff, and the run record — never the build conversation. A grader that watched the work is not an independent check, and reusing the builder's context is the fastest way to a fake pass.
2. **Return a defect list, not a verdict.** Per criterion: id, class, evidence, and for a `fail` a severity of `blocker`, `major`, or `minor` plus the specific defect — plus the criteria it can see are unreachable. The grader does not return `score` or `gate`; a fresh context does not know the round number, how many rounds remain, or whether a read-only measurement was asked for. The loop controller computes those from the verdicts and `max_grader_rounds`. Severity sets repair order; only pass/fail decides whether the gate opens.
3. **Route failures narrowly.** Each defect goes to the responsible worker through the existing repair router, not back through the whole graph.
4. **Re-grade the whole rubric.** The next round re-checks every criterion, not only the repaired ones, so a fix cannot silently break a criterion that already passed.
5. **Never edit the rubric mid-loop.** The criteria are fixed before the first round. If a criterion turns out to be wrong, stop the loop, say so, and get the user's decision — do not soften the criterion, drop it, or mark it not applicable to make the score rise.
6. **Stop at the cap.** The loop ends at a full applicable score or at `max_grader_rounds`. Hitting the cap with criteria still failing is a capped result, not a completed one; report the score, the open defects, and what remains.

```text
build -> fresh grader -> full score? -> yes -> human gate
                           |
                           no -> defect list -> narrow repair -> re-grade (round + 1)
                                                                   |
                                                        rounds spent -> capped: report and stop
```

The round's output shape is fixed: see [references/grader-output.md](references/grader-output.md).

For a small single-loop task, this collapses to one grading pass over a short rubric. Do not spawn a grader graph for work that a single fresh read can settle.

## Default Response Shape

Report one consolidated result, not a transcript from every worker. Never fabricate worker output,
test results, scan results, URLs, commits, or successful external actions. Report on every outcome:
a capped run, an abandoned run, and a run whose workers failed all get the same report, saying what
did and did not happen.

Read [references/output-contracts.md](references/output-contracts.md) for the required report contents.

## Pitfalls

The common failure modes — fake edges, unisolated writers, anchorless audits, self-graded
acceptance, and treating a self-report as proof — are catalogued in
[references/pitfalls.md](references/pitfalls.md). Read it when a graph feels wrong but no rule has
obviously been broken.

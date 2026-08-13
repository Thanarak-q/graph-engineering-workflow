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
10. **Cap the graph.** Before dispatching any non-trivial graph, set explicit limits for worker count, concurrency, waves, retries, time, and budget. Unset or zero-valued limits are not valid defaults. Scale only after a small pilot is inspectable.
11. **Gate irreversible actions.** Commit, push, deploy, publish, delete, payment, and external sends require an explicit human gate unless the user has already granted a clear equivalent approval for that exact action.
12. **Report evidence, not confidence.** Never call work complete because a worker says it is complete.

## User Interaction

When a request is ambiguous, ask one high-value question at a time before writing code. Do not ask a generic “what is the pain point?” for a precise coding request; ask about the missing behavior, scope, constraint, or success condition.

Use choices when the decision has a bounded set of answers and allow a free-text alternative:

- offer no more than four useful choices;
- include `Other (type your answer)` when appropriate;
- let the user correct the choice;
- do not hide a meaningful trade-off inside a default.

On Hermes, use the native `clarify` tool when available. On Codex or Claude Code, present a short numbered choice list and accept a typed answer.

After clarification, state the confirmed objective, scope, acceptance criteria, constraints, and unresolved questions. If the request is clear and low-risk, a concise confirmation is enough. For a multi-writer, sensitive, or high-impact graph, show the graph plan and wait for approval before implementation.

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

1. receive a bounded task and acceptance checks;
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
    status: pending|running|passed|failed

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
approvals:
  graph: pending|approved|not_required
  commit: pending|approved|not_requested
  push: pending|approved|not_requested
  deploy: pending|approved|not_requested
```

## Cross-Provider Use

Use the host's native execution mechanism, but keep the graph contract unchanged:

- **Hermes:** use `delegate_task` for bounded isolated workers when appropriate; use native `clarify` for choices; keep one parent merge owner; verify returned artifacts yourself.
- **Codex:** use native subagents or separate bounded `codex` executions when available; use isolated worktrees for concurrent writers; otherwise run the graph sequentially rather than pretending it was parallel.
- **Claude Code:** use native subagents, teams, or isolated worktrees when available; keep verifier context separate from executor context; collect structured reports before merging.

A platform limitation is not permission to claim that a worker ran, a verifier checked something, or parallelism occurred. Report what actually executed.

## Graph Plan Output

Before executing a non-trivial graph, show a compact plan:

```text
GRAPH PLAN
Objective: ...
Independent units: ...
Real dependencies: ...
Parallel groups: ...
Worker ownership/isolation: ...
Verifier and anchors: ...
Audit nodes selected: ...
Repair routes: ...
Limits: explicit numeric worker/concurrency/wave/retry caps plus time and budget
Human gates: ...
```

Ask for user approval when the graph has material scope, cost, security, privacy, data-loss, or multi-writer trade-offs. Do not ask for approval merely to run a read-only inspection the user already requested.

## Default Response Shape

Report one consolidated result, not a transcript from every worker. Include:

- graph shape actually used;
- workers completed and artifacts they produced;
- files or paths changed;
- anchors actually run and their real results;
- audit results by dimension;
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

## Verification Checklist

Before declaring the graph complete, confirm:

- independent units and real edges are documented;
- fake edges were removed;
- every worker has a bounded input, output, owner, and stop condition;
- concurrent writers were isolated;
- research claims have evidence and fresh verification;
- each audit used a real anchor or is explicitly marked as an unverified review;
- conflicts and repairs were routed and recorded;
- actual tests/scans/builds were run and their output was inspected;
- worker, concurrency, retry, and budget caps were respected;
- the final artifact was read back or executed;
- human gates were honored before irreversible actions;
- the final report separates facts, assumptions, decisions, and unresolved risks.

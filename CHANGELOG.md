# Changelog

All notable changes to this skill are recorded here. Versions follow
[Semantic Versioning](https://semver.org/); for an instruction set, "breaking" means a change that
alters what an agent carrying the skill will do.

## [2.5.0] — 2026-08-21

A review of the whole skill against itself. The gate could open with the outcome ungraded, the
rubric graded seven things the state contract had no field for, and the eval suite's assertion
vocabulary was 87 tokens used once each.

Numbered 2.5.0 rather than 2.2.0: 2.2 through 2.4 were never released, and the jump marks the size
of the change. Several items here alter what an agent carrying the skill will do — outcome criteria
can no longer be marked not applicable, the grader no longer emits a gate, and the state contract
gained required fields — which by this file's own definition is breaking. It follows the precedent
2.1.0 set for a behavior-altering release inside the v2 line.

### Fixed

- **The gate could open on process alone.** `SKILL.md` said a small graph "may legitimately be
  accepted at 7/7" and, four paragraphs later, that "passing all ten process criteria is not a
  passing graph on its own." Both were reachable, because nothing required an outcome criterion to
  exist: a user who never stated acceptance criteria got zero of them, `passed == applicable` was
  satisfied at 10/10, and a well-run graph shipping the wrong behavior read as accepted — the exact
  v1 failure v2 was built to fix. Every graph now carries at least one outcome criterion, derived
  from the request when none was confirmed, and stated in the graph plan. New eval
  `24-no-acceptance-criteria`.
- **`not_applicable` was a one-word gate bypass.** The rubric allowed NA on any criterion and
  excluded it from the denominator. Applied to C11+, that drops a user requirement out of the score
  and opens the gate without building anything — the rubric-softening that rule 5 and eval 17 exist
  to prevent, except eval 17 only tested the pressure on a process criterion. Outcome criteria are
  now never `not_applicable`; a requirement that stopped applying is a scope change the user
  decides. New eval `23-outcome-criterion-not-na`.
- **The grader was told to return "not a verdict" and handed a verdict-shaped contract.** Fresh
  Grader Loop rule 2 said "return a defect list, not a verdict" while `references/grader-output.md`
  opened with `score` and `gate`. Worse, `gate: capped` is uncomputable by a fresh context, which
  knows neither the round number nor `max_grader_rounds`. The grader now returns per-criterion
  verdicts plus `unreachable`; the loop controller computes `round`, `score`, and `gate`.
- **A read-only score had no honest gate value.** The enum was `passed | blocked | capped`, so a
  measurement nobody asked to gate had to be recorded as `blocked` — reporting a ceiling set by the
  user's own request as a deficiency in the work, which is what 2.1.0 added eval 22 to stop. Added
  `gate: measured`. New eval `30-read-only-anchors-allowed` also settles that "change nothing" means
  tracked source, artifacts, and history — not the filesystem — so anchors still run and C6 stays
  reachable in a read-only round.
- **`wave` was graded but never defined.** C8 and `max_waves` required a cap on a unit the skill
  never introduced. A wave is now one dispatch of a parallel group.
- **README C1–C10 re-synced with the rubric** and carry the evidence class.

### Added

- **Evidence classes on every criterion.** `artifact` and `rerun` criteria the grader settles for
  itself; `record` criteria it can only read from the run log. This names a hole the skill had
  papered over: with the build conversation withheld, C1, C2, C7, and C8 are graded against the
  builder's own account of the run — self-reporting, which every other rule here refuses. Two
  constraints keep it load-bearing: the run log is appended *during* the run, not composed after
  it, and no arrangement of record-class passes opens the gate while an outcome criterion is
  failing. The report says which criteria were attested rather than checked.
- **The state contract now holds what the rubric grades.** Seven of ten process criteria demanded
  evidence with no field to hold it: `rejected_edges` (C1); `write_boundary`, `stop_condition`,
  `verifier`, and `evidence_required` on workers (C2); a typed `claims` block (C4);
  `result: unverified_review` (C5); typed `conflicts` and `repairs` (C7); an `observed` block of
  counts to compare against every cap (C8); and `approvals` for publish, delete, payment, and
  external send (C9). Plus `run_log`, and `human_substitution` under `acceptance`.
- **Worker failure is specified.** A worker that fails, times out, returns nothing, or breaks its
  output contract is `failed` or `unusable_output` with a reason; its unit is retried, rerouted, or
  recorded as not done, and its intended artifact is never reported as produced. This was the most
  common real failure in multi-agent orchestration and the skill was silent on it — silence that
  defaults to assuming the output arrived. New eval `25-worker-output-unusable`.
- **Nesting is bounded.** `max_depth` caps subgraph nesting, nested workers count against
  `max_workers`, and `parent`/`depth` are recorded per worker. A hierarchical graph could previously
  run three owners spawning three each under a cap of six with every cap nominally "set". New eval
  `26-nested-worker-cap`.
- **Scoped the human substitution for the gate.** "An explicit human decision substitutes for an
  independent gate where that is allowed" never said where. It is allowed in one case — the host
  cannot give the grader a separate context — and it replaces the missing independence, never a
  failing criterion. New eval `29-self-graded-gate`.
- **`evals/lexicon.md`.** 89 tokens, each defined as something a grader can point at in a trace, and
  a `must_any` list for behavior the skill allows to be satisfied more than one way. The suite had
  91 distinct tokens across 22 cases with 87 used exactly once, including `shared_working_tree` and
  `shared_workspace_writes` for the same observable. That is not an assertion language, and it
  cannot support comparing results across hosts or versions — the stated purpose of the suite.
- **`scripts/check.sh` and CI.** Verifies every relative link resolves, every case parses and its id
  matches its filename, every token is defined, no case both requires and forbids a token,
  `SKILL.md` stays near the size guidance, and `git diff --check` is clean. Both failure modes were
  tested against deliberately broken inputs.
- **Nine new eval cases**, 22 → 31: the two gate bypasses above, worker failure, nested caps,
  read-only anchors, self-graded gates, plus `27-merge-conflict-routing`, `28-no-repository-task`,
  and `31-discovery-expansion-stop`.
- **`references/rubric.md`** and **`references/audits.md`**, and the routing rules moved into
  `references/skill-routing.md`.
- **Adapters for Antigravity, Codex, and Hermes**, plus `adapters/README.md` carrying the shared
  portability rules and a status column that says "notes only — no recorded trace" for all four.
  The README's four-host badge asserted support no trace backs, which is the claim this skill
  refuses in every other context.
- **`.gitignore`** for `.claude/`, which was excluded only through local `.git/info/exclude`.

### Changed

- **Skill Discovery has a fallback.** Where a host exposes no skill inventory, record the pass as
  skipped with that reason rather than guessing at names or claiming a routing pass happened.
- **Operating Principles: fourteen rules.** Added "never infer a worker's success", and rules 10–13
  now restate their binding constraint inline rather than pointing at a section that had become a
  three-line pointer to `references/`.
- **The report is produced on every outcome**, including a capped or abandoned run. The README
  diagram had `CAP` as a terminal node, so reporting looked conditional on passing.

### Size

`SKILL.md` is 21.4 KB / 290 lines, roughly 5.6k estimated tokens — effectively flat against 2.1.0's
21.2 KB while carrying eight new rules, achieved by moving the rubric, the audit menu, and the
routing rules into `references/`. Still above the ~5,000-token guidance rather than under it, which
is worth saying plainly instead of rounding down.

### Known gaps

- No eval case has been run against a host, so no portability or behavior claim in this repository
  is demonstrated. `scripts/check.sh` validates the cases; it does not execute them.
- There is still no automated eval runner. It needs to invoke a host agent and inspect an execution
  trace, which is a separate piece of work.
- Record-class criteria remain attested rather than independently checked. The run-log rule narrows
  the hole; it does not close it. Closing it needs a log the builder cannot retroactively edit.

## [2.1.0] — 2026-08-21

A grading mode that could silently switch the acceptance loop off, and a gate vocabulary that meant
two opposite things.

### Removed

- **`score-only` and `hybrid` are gone.** The rubric now runs one way: a fresh grader scores it,
  failures route to their owners, the whole rubric is re-graded, and the loop ends on a full
  applicable score or `max_grader_rounds`. The justification for a separate read-only mode did not
  hold — the grader never repaired anything in either mode, since defects go to the repair router
  and the next round is scored by a fresh grader again. Independence comes from context isolation
  and ownership routing, so `score-only` was not protecting a property `hybrid` lacked; it was
  `hybrid` with the loop switched off, reachable by typing a mode name. A read-only score survives
  as a plain request — "grade this, don't change anything" — which runs one round and stops.
- **`acceptance.mode`** is dropped from the state contract and the grader-round output.

### Fixed

- **`closed` no longer means both "accepted" and "not accepted".** The rubric section said the
  graph "closes" when every applicable criterion passes, while the state contract and the grader
  output used `gate: closed` for a *failing* score. Gate values are now
  `passed | blocked | capped`, acceptance is stated as "accepted" rather than "closed", and the
  verb for opening the gate is "opens" everywhere.
- **Evals 13 and 14 no longer contradict each other.** `13` required `gate_closed` when an outcome
  criterion fails; `14` forbade `gate_closed` on a read-only run. A read-only run that found a
  defect tripped both. `13` now expects `gate_blocked`, and `14` is rewritten as
  `read-only-score` expecting `declared_accepted` in `must_not`.
- **README C2, C8, and C9 re-synced with `SKILL.md`.** They were paraphrases that had drifted; C8
  still required every cap "set explicitly and respected", which is unsatisfiable under
  `budget.kind: none` — the same contradiction 2.0.1 fixed in `SKILL.md` and never propagated.

### Added

- **Unreachable criteria must be named before the round, not after.** An outcome criterion that
  describes a defect cannot reach `pass` while writes are withheld, so a read-only round now has to
  say which criteria are capped by the request itself. Without this, a read-only score reports a
  ceiling set by the mode as if it were a shortfall in the work. New eval `22-unreachable-criterion`.

## [2.0.1] — 2026-08-19

Two contradictions introduced by the v2.0.0 work, both found in review.

### Fixed

- **`10/10` no longer means "complete".** The rubric section still opened with "complete when a
  fresh grader scores 10/10" — wording written before outcome criteria existed — while the section
  directly below it said a task with three acceptance criteria is graded out of thirteen and that
  ten process passes are not a passing graph. The gate condition is now stated once, as
  `passed == applicable`, and the loop and its diagram end on a full applicable score rather than a
  fixed number.
- **Budget wording reconciled.** The Graph Plan template required "a budget in a unit this host can
  observe", which is impossible to satisfy under `kind: none` — the escape hatch the state contract
  explicitly allows. The template now accepts an observable cap *or* `none` with a reason.

## [2.0.0] — 2026-08-19

v1 could run a graph correctly and still ship the wrong thing. It verified that every step was
performed, but nothing verified that the result satisfied the request. v2 adds the missing half —
an acceptance gate that grades the outcome — and repairs four structural problems found while
building it.

### Added

- **Acceptance rubric.** Ten fixed process criteria (C1–C10), each binary and each requiring an
  evidence pointer: a `file:line`, a command and its output, or an artifact id. Replaces the
  Verification Checklist, which had become an unverifiable self-check.
- **Outcome criteria (C11+).** One criterion per acceptance criterion confirmed with the user,
  derived from `task.acceptance_criteria` and graded against a real anchor. A task with three
  acceptance criteria scores out of 13, so the number describes the work rather than the ceremony.
- **Fresh grader loop.** The grader never receives the build conversation. It returns a
  severity-ranked defect list instead of a verdict, failures route through the existing repair
  router, and the whole rubric is re-graded each round so a fix cannot silently break a criterion
  that already passed. The rubric is fixed before round one and may not be softened mid-loop.
- **Grading modes.** `hybrid` (default) grades and repairs. `score-only` measures without writing,
  and never closes the gate on its own.
- **`self_graded` degradation.** Where a host cannot provide an independent context, the score is
  recorded as `self_graded` and requires a human decision in place of the gate.
- **`references/`.** Seven files the core skill loads on demand: state contract, host guidance,
  output contracts, grader output, research output, skill routing map, and pitfalls.
- **`evals/`.** Twenty-one behavior cases across ten categories, each a prompt plus the behaviors
  that must and must not appear. No case has been executed against a host yet, and `evals/README.md`
  says so plainly.
- **`CHANGELOG.md`.** This file.

### Changed

- **Frontmatter is provider-neutral.** The description said "Use when Codex or Claude needs to…"
  while the README claimed four hosts. Since the description is the mechanism a host uses to decide
  whether to activate a skill, naming two hosts suppressed activation on the other two. It now
  names none, and carries the negative boundary — prefer a single loop for small or sequential
  tasks — in the metadata itself. Added `license: MIT`.
- **Budget is portable.** `budget` was required to be a token or cost limit, which many runtimes do
  not expose, so the rule forced either a fabricated number or a rule violation. It is now
  `{kind, value, reason}` over `worker_turns | tool_calls | tokens | cost | none`, and must name a
  unit the host can actually observe. `kind: none` with a reason is a valid, honest answer; C8 was
  widened to match.
- **Operating Workflow → Operating Principles.** The thirteen rules restated in full what the
  detailed sections already specify. Two statements of one rule drift, and the reader had no way to
  know which governed. Each rule is now trimmed to its imperative and points at its section, with
  the section declared normative on any disagreement.
- **Skill routing reaches the workers.** Selected skills are now part of the work-unit and
  implementation-worker contracts, workers use what they are handed and report gaps rather than
  self-selecting from their own environment listing, the grader may use read-only review skills but
  never one that writes, and C2 grades that the plan's skill assignment actually arrived.
- **Skill Discovery is scoped to non-trivial requests.** Requiring it "for every request"
  contradicted the skill's own instruction not to force the graph onto small tasks.
- **Manual installation is generic.** The README hardcoded per-agent global paths that drift with
  the ecosystem and fail silently when stale. It now says to copy the directory and links the
  `skills` CLI docs as the source of truth. This is also required by `references/`: copying
  `SKILL.md` alone now installs a skill pointing at files that do not exist.
- **README rewritten for v2** with the rubric, the modes, a worked grader round, and a walkthrough
  showing a failing outcome criterion being repaired.
- **AGENTS.md review commands** truncated `SKILL.md` at 240 lines; they now read the whole file.

### Removed

- **Canonical Shape for Coding Work.** It restated Graph Construction in diagram form.
- **Verification Checklist.** Superseded by the acceptance rubric.

### Size

`SKILL.md` went from 480 lines / 27.0 KB to 317 lines / 20.9 KB (roughly 5.2k estimated tokens)
by moving templates and reference material into `references/`. The rubric work had pushed the file
well past the ~5,000-token guidance for a skill that loads in full on activation.

### Known gaps

- No eval case has been run against a host, so no portability or behavior claim in this repository
  is demonstrated. The portability matrix is deliberately absent until traces exist.
- There is no automated eval runner; cases are run by hand.
- No adapter exists for Antigravity or Hermes. `adapters/claude.md` is the only real adapter, and
  `agents/openai.yaml` is display metadata rather than an adapter.

## [1.0.0]

Initial portable skill: bounded agent graphs, the fake-edge test, fresh verification, isolated
writers, single-owner merge, narrow repair routing, execution caps, and human gates.

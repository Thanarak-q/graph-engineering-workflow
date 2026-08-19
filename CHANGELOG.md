# Changelog

All notable changes to this skill are recorded here. Versions follow
[Semantic Versioning](https://semver.org/); for an instruction set, "breaking" means a change that
alters what an agent carrying the skill will do.

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

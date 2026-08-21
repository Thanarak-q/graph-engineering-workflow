# Pitfalls

Failure modes seen in real graph runs. Each is the inversion of a rule in `SKILL.md`; consult this
list when a graph feels wrong but no rule has obviously been broken.

## Topology

- Treating a linear checklist as a graph.
- Adding an edge because the prose says “then.”
- Spawning one worker per stage instead of one worker per independent unit.
- Giving every worker the full shared conversation and calling the result independent.

## Isolation and merge

- Letting workers edit the same workspace or artifact without isolation.
- Merging conflicting research without provenance or a judge.

## Verification

- Running an audit that has no anchor and reporting an opinion as verification.
- Running every audit for every change.

## Scale and boundaries

- Scaling before measuring cost, failure rate, and merge quality.
- Using a role name as a security boundary.
- Letting an optimizer change the metric, policy, or acceptance rule it is being judged against.
- Treating a worker's self-report as proof that an artifact exists.

## Acceptance grading

- Giving the acceptance grader the build conversation and still calling it a fresh grader.
- Rewriting, softening, or dropping a rubric criterion during the loop instead of fixing the work.
- Reporting a rubric score without the evidence pointer that earned each pass.
- Declaring completion after the grader round cap when criteria are still failing.

## Acceptance grading, continued

- Marking an outcome criterion `not_applicable` — dropping a user requirement out of the
  denominator is a rubric edit, not a verdict.
- Accepting a graph on C1–C10 alone because the user never stated acceptance criteria explicitly.
- Composing the run record after the work finishes and grading the record-class criteria against it.
- Letting the grader compute its own `gate`, which requires knowing a round budget a fresh context
  cannot see.
- Reporting a read-only score as `blocked`, so a ceiling set by the request reads as a shortfall in
  the work.

## Workers and scale

- Inferring success from a worker that returned nothing, timed out, or broke its output contract.
- Letting a subgraph's nested workers escape the graph-wide worker cap.
- Setting caps and never recording what actually happened against them, so "limits held" is
  unfalsifiable.

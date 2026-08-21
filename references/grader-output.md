# Grader Round Output

A grader round returns exactly this shape: one verdict per criterion, plus the criteria it can see
are unreachable. It does not return `score` or `gate`.

The grader is a fresh context. It knows the rubric, the artifacts, the diff, and the run record —
it does not know the round number, how many rounds remain, or whether the caller asked for a
read-only measurement. `round`, `score`, and `gate` are computed by the loop controller from this
output plus `limits.max_grader_rounds`, and are recorded under `acceptance` in the state contract.

```yaml
criteria:
  - id: C6
    verdict: pass
    class: rerun
    severity: none
    evidence: "pnpm test -- auth/: 48 passed, 0 failed"
  - id: C4
    verdict: not_applicable
    class: artifact
    severity: none
    evidence: "no external research node ran"
  - id: C11
    verdict: fail
    class: rerun
    severity: blocker
    evidence: "POST /login with a valid password returns 500; src/auth/session.ts:74"
    defect: "session write happens before the transaction commits"
  - id: C9
    verdict: fail
    class: artifact
    severity: major
    evidence: "git log shows commit 4a1c2f9 with approvals.commit still pending"
    defect: "committed without the human gate"
unreachable:
  - id: C11
    reason: "describes a defect in the code; cannot reach pass while writes are withheld"
```

What the controller does with it:

```yaml
acceptance:
  round: 2
  score: "11/13"
  gate: blocked          # passed | blocked | capped | measured
```

- `passed` — every applicable criterion passed.
- `blocked` — criteria are failing and rounds remain under `max_grader_rounds`.
- `capped` — criteria are failing and `max_grader_rounds` is spent. Capped is not complete.
- `measured` — a read-only round. No gate decision was taken, because none was asked for.

## Unreachable criteria

`unreachable` is filled before the round is reported, not discovered after it. A criterion is
unreachable when no re-grade of the same state can move it — most often an outcome criterion that
describes a defect still present in the code, graded while writes are withheld.

A score held down by unreachable criteria is a ceiling set by the request, and must be reported as
that rather than as a shortfall in the work.

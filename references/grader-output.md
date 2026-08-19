# Grader Round Output

A grader round returns exactly this shape. Every criterion carries a verdict and an evidence
pointer; a `fail` also carries a severity and the specific defect.

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


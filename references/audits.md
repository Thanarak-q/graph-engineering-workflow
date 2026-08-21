# Audit Dimensions and Anchors

The menu the Audit Graph selects from. Select by the change and its risk; running every audit for
every change is its own failure mode.

## Audit workers

- **security:** authentication, authorization, injection, secrets, unsafe defaults,
  deserialization, dependency risk;
- **privacy:** PII, logging, data exposure, retention, access boundaries, telemetry, data flow;
- **functional:** acceptance criteria and expected behavior;
- **input/edge:** empty, malformed, boundary, oversized, unexpected, and adversarial input;
- **regression:** behavior outside the changed area;
- **code quality:** error handling, duplication, complexity, maintainability, type safety, and
  unintended diff;
- **dependency/SCA:** versions, vulnerabilities, licenses, and lockfile integrity.

## Anchors, in preference order

- actual test commands and their output;
- compiler, type checker, and linter output;
- security or dependency scanner output;
- an API call or integration check;
- a direct code/data-flow inspection with exact locations;
- immutable policy or acceptance rules.

An audit worker may explain a risk, but "looks safe" is not a security result and "tests should
pass" is not a test result. An audit that reached no anchor is recorded with
`result: unverified_review` and labeled that way in the report — the escape hatch is honest
labeling, not silence, and not an invented scanner output.

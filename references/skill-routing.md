# Known Skill Routing Map

Match a node to a companion skill when one is available in the current environment. Nothing here
is required: the workflow runs standalone, and a skill that is absent is recorded as skipped.

- `grilling` for a user-requested or high-trade-off decision
- `to-spec` or `domain-modeling` for requirements and domain design
- `codebase-design` for codebase investigation and architecture
- `research` for external research
- `implement` or `tdd` for implementation and verification
- `code-review` for code-quality audit
- `devsecops` for security, privacy, or dependency audit
- `diagnosing-bugs` for repair
- `resolving-merge-conflicts` for merge
- `handoff` for a final transfer
- `prototype` or `improve-codebase-architecture` when their specific purpose applies

## Routing rules

Graph Engineering Workflow controls topology, ownership, isolation, limits, merge, repair, and
reporting. A selected skill controls its domain workflow only; it must not expand the graph,
override limits, or bypass human gates.

Choose skills for their expected value, not because they match a keyword. Multiple skills may be
selected when their responsibilities do not overlap. When they overlap, select the more specific or
safer skill and record why the other was skipped.

**A worker uses the skills it was handed and does not go shopping for more.** Its own environment
may list skills the parent did not select; that listing is not a mandate. A worker that decides it
needs another skill reports the gap in its output instead of expanding its own scope. The parent
owns routing because only the parent can see the whole graph.

**Route the acceptance grader like any other node.** It may use a read-only review or audit skill
that helps it check a criterion. It may never use a skill that writes, repairs, or otherwise
changes what it is grading.

Skill Discovery runs before the graph is selected, so its first pass is an inventory, not a final
assignment. Bind skills to nodes once the units exist, and record any skill added later with the
round or node that introduced it.

If a selected skill is unavailable at execution time or conflicts with the task constraints,
continue with the base workflow and record it as skipped. Do not install, request installation of,
or block on an optional companion skill during a graph run.

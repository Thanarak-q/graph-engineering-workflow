#!/usr/bin/env bash
# Repository checks for the graph-engineering-workflow skill.
# No build system: what is checkable here is internal consistency.
#
#   1. every relative markdown link resolves
#   2. every eval case parses as YAML and has the required keys
#   3. every expectation token is defined in evals/lexicon.md
#   4. the README rubric table matches references/rubric.md
#   5. SKILL.md stays near the always-loaded size guidance
#   6. no whitespace errors
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
note() { printf '  %s\n' "$1"; }
step() { printf '\n== %s\n' "$1"; }
bad()  { fail=1; note "FAIL: $1"; }

step "1. relative links resolve"
broken=0
while read -r f; do
  d=$(dirname "$f")
  while read -r t; do
    [ -z "$t" ] && continue
    if [ ! -e "$d/$t" ]; then bad "$f -> $t"; broken=$((broken+1)); fi
  done < <(grep -Eo '\]\([a-zA-Z0-9_./-]+\.(md|sh|yaml|yml)\)' "$f" | sed 's/^](//;s/)$//')
done < <(find . -name '*.md' -not -path './.git/*')
note "checked $(find . -name '*.md' -not -path './.git/*' | wc -l) markdown files, $broken broken links"

step "2 + 3. eval cases parse, and every token is in the lexicon"
python3 - <<'PY' || fail=1
import re, sys, pathlib, json
root = pathlib.Path('.')
lex = (root/'evals/lexicon.md').read_text()
defined = set(re.findall(r'^\| `([a-z_]+)`', lex, re.M))
if not defined:
    print("  FAIL: no tokens parsed out of evals/lexicon.md"); sys.exit(1)

try:
    import yaml
    load = yaml.safe_load
except ImportError:
    print("  note: PyYAML absent, using a minimal parser for the fixed case shape")
    def load(text):
        out, cur = {}, None
        for line in text.splitlines():
            m = re.match(r'^(\w+):\s*(.*)$', line)
            if m:
                cur = m.group(1); out[cur] = m.group(2).strip() or {}
                continue
            m = re.match(r'^  (\w+):\s*\[(.*)\]\s*$', line)
            if m and isinstance(out.get(cur), dict):
                out[cur][m.group(1)] = [t.strip() for t in m.group(2).split(',') if t.strip()]
        return out

cases = sorted((root/'evals/cases').glob('*.yaml'))
if not cases:
    print("  FAIL: no eval cases found"); sys.exit(1)
bad = 0
used = set()
for c in cases:
    try:
        data = load(c.read_text())
    except Exception as e:
        print(f"  FAIL: {c.name} does not parse: {e}"); bad = 1; continue
    for key in ('id', 'category', 'prompt', 'expect'):
        if key not in data:
            print(f"  FAIL: {c.name} missing key '{key}'"); bad = 1
    if c.stem.split('-', 1)[-1] != data.get('id'):
        print(f"  FAIL: {c.name} id '{data.get('id')}' does not match its filename"); bad = 1
    exp = data.get('expect') or {}
    if not any(exp.get(k) for k in ('must', 'must_any', 'must_not')):
        print(f"  FAIL: {c.name} has no expectations"); bad = 1
    for key in ('must', 'must_any', 'must_not'):
        for tok in exp.get(key) or []:
            used.add(tok)
            if tok not in defined:
                print(f"  FAIL: {c.name} uses undefined token '{tok}'"); bad = 1
    for tok in set(exp.get('must') or []) & set(exp.get('must_not') or []):
        print(f"  FAIL: {c.name} requires and forbids '{tok}'"); bad = 1

print(f"  {len(cases)} cases, {len(used)} distinct tokens, {len(defined)} defined")
orphans = sorted(defined - used)
if orphans:
    print(f"  note: {len(orphans)} defined but unused: {', '.join(orphans)}")
reuse = len(used) / len(cases)
print(f"  token reuse: {reuse:.2f} tokens per case ({len(used)} tokens over {len(cases)} cases)")
sys.exit(bad)
PY

step "4. README rubric matches references/rubric.md"
python3 - <<'RUBRIC' || fail=1
import re, sys
rub = open('references/rubric.md').read()
rows = re.findall(r'^\| (C\d+) \| ([^|]+?) \| (`\w+`) \| (.+?) \|$', rub, re.M)
if len(rows) != 10:
    print(f"  FAIL: expected 10 criteria in references/rubric.md, found {len(rows)}"); sys.exit(1)
rd = open('README.md').read()
bad = 0
for cid, name, cls, cond in rows:
    m = re.search(r'^\| \*\*' + cid + r'\*\* \| ([^|]+?) \| (`\w+`) \| (.+?) \|$', rd, re.M)
    if not m:
        print(f"  FAIL: {cid} missing from the README rubric table"); bad = 1; continue
    if (m.group(1), m.group(2), m.group(3)) != (name, cls, cond):
        print(f"  FAIL: {cid} has drifted between references/rubric.md and README.md"); bad = 1
print(f"  {len(rows)} criteria compared" + ("" if bad else ", README in sync"))
sys.exit(bad)
RUBRIC

step "5. SKILL.md size"
bytes=$(wc -c < SKILL.md)
approx=$((bytes * 10 / 38))
note "SKILL.md ${bytes} bytes, roughly ${approx} tokens (guidance: ~5000, always loaded)"
[ "$approx" -gt 7000 ] && bad "SKILL.md is well over the always-loaded size guidance"

step "6. whitespace"
git diff --check && note "clean" || bad "whitespace errors"

printf '\n'
[ "$fail" -eq 0 ] && { echo "all checks passed"; exit 0; } || { echo "checks FAILED"; exit 1; }

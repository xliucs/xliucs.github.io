#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
index="$repo_dir/index.html"

assert_contains() {
  local text="$1"
  rg --fixed-strings --quiet "$text" "$index" || {
    echo "Missing from index.html: $text" >&2
    return 1
  }
}

assert_absent() {
  local text="$1"
  if rg --fixed-strings --quiet "$text" "$index"; then
    echo "Stale content in index.html: $text" >&2
    return 1
  fi
}

assert_contains '<div class="title">Gemma 4 Technical Report</div>'
assert_contains 'https://arxiv.org/abs/2607.02770'
assert_contains '<div class="title">Capable language models can outgrow the benefits of collaboration</div>'
assert_contains '<div class="venue">Nature Machine Intelligence, 2026</div>'
assert_contains 'https://www.nature.com/articles/s42256-026-01268-y'
assert_contains '<div class="venue">Under Revision at Nature, 2025</div>'
assert_absent 'Towards a Science of Scaling Agent Systems'
assert_absent '<div class="venue">Accepted at Nature Machine Intelligence, 2026</div>'

echo "Website publication checks passed"

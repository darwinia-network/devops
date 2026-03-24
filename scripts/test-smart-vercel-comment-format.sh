#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMATTER="${ROOT_DIR}/actions/smart-vercel/bin/render-preview-output.sh"

assert_eq() {
  local expected="$1"
  local actual="$2"
  local name="$3"

  if [ "${expected}" != "${actual}" ]; then
    echo "assertion failed: ${name}" >&2
    echo "expected:" >&2
    printf '%s\n' "${expected}" >&2
    echo "actual:" >&2
    printf '%s\n' "${actual}" >&2
    exit 1
  fi
}

main() {
  local actual expected

  actual="$("${FORMATTER}" render-entry "f56896b" "https://degov-home-a19ab32qi-itering.vercel.app")"
  expected=$'- comment: f56896b\n  preview: https://degov-home-a19ab32qi-itering.vercel.app'
  assert_eq "${expected}" "${actual}" "renders yaml-style preview entry"

  actual="$("${FORMATTER}" render-entry "113a1fd" $'https://degov-home-mbjpfedv3-itering.vercel.app\nhttps://alias.vercel.app' "staging")"
  expected=$'- section: staging\n  comment: 113a1fd\n  preview: https://degov-home-mbjpfedv3-itering.vercel.app https://alias.vercel.app'
  assert_eq "${expected}" "${actual}" "normalizes multiline preview links and preserves section metadata"

  actual="$("${FORMATTER}" normalize-link $'https://preview.vercel.app\r\nhttps://alias.vercel.app')"
  expected='https://preview.vercel.app https://alias.vercel.app'
  assert_eq "${expected}" "${actual}" "normalizes raw preview link output"

  echo "smart-vercel comment formatter tests passed"
}

main "$@"

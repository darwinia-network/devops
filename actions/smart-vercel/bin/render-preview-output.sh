#!/usr/bin/env bash

set -euo pipefail

normalize_link() {
  printf '%s' "${1}" | tr '\r\n' ' ' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
}

render_entry() {
  local sha="$1"
  local preview_link
  local preview_section="${3:-}"

  preview_link="$(normalize_link "$2")"

  if [ -n "${preview_section}" ]; then
    printf -- "- section: %s\n  comment: %s\n  preview: %s\n" "${preview_section}" "${sha}" "${preview_link}"
    return
  fi

  printf -- "- comment: %s\n  preview: %s\n" "${sha}" "${preview_link}"
}

usage() {
  echo "usage: $0 <normalize-link|render-entry> ..." >&2
  exit 1
}

main() {
  local command="${1:-}"

  case "${command}" in
    normalize-link)
      [ $# -eq 2 ] || usage
      normalize_link "$2"
      ;;
    render-entry)
      [ $# -ge 3 ] && [ $# -le 4 ] || usage
      render_entry "$2" "$3" "${4:-}"
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"

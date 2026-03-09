#!/bin/bash
# cdup: go up N directories, or jump to nearest ancestor by name.
# This script outputs the target directory when executed directly.
# When sourced, it defines the cdup function.

cdup_find_target() {
  local arg nwd d target found

  # Enforce 0 or 1 argument
  if (( $# > 1 )); then
    printf 'cdup: expected 0 or 1 argument, got %d\n' "$#" >&2
    return 2
  fi

  # No argument: default behavior
  if (( $# == 0 )); then
    dirname -- "$PWD"
    return 0
  fi

  arg=$1

  # Help
  if [[ $arg == "-h" || $arg == "--help" ]]; then
    cat <<'EOF' >&2
Usage:
  cdup
      Go up one directory (same as: cd ..)

  cdup N
      Go up N directory levels (N must be a positive integer)

  cdup NAME
      Jump to the nearest ancestor directory named NAME

  cdup -h | --help
      Show this help

Examples:
  cdup
  cdup 3
  cdup src
EOF
    return 2
  fi

  # Reject empty/whitespace-only argument
  if [[ -z "${arg//[[:space:]]/}" ]]; then
    printf 'cdup: argument cannot be empty\n' >&2
    return 2
  fi

  # Numeric mode: positive integer only
  if [[ $arg =~ ^[0-9]+$ ]]; then
    if (( arg < 1 )); then
      printf 'cdup: numeric argument must be >= 1\n' >&2
      return 2
    fi

    nwd=$PWD
    while (( arg > 0 )); do
      d=$(dirname -- "$nwd")
      if [[ $d == "$nwd" ]]; then
        break
      fi
      nwd=$d
      ((arg--))
    done

    printf '%s\n' "$nwd"
    return 0
  fi

  # Name mode: jump to nearest ancestor directory containing "$arg" (case-insensitive)
  target=$(echo "$arg" | tr '[:upper:]' '[:lower:]')
  nwd=$(dirname -- "$PWD")
  found=''

  while :; do
    if [[ $(basename -- "$nwd" | tr '[:upper:]' '[:lower:]') == *"$target"* ]]; then
      found=$nwd
      break
    fi

    d=$(dirname -- "$nwd")
    [[ $d == "$nwd" ]] && break
    nwd=$d
  done

  if [[ -z $found ]]; then
    printf 'cdup: "%s" not found in current path ancestry: %s\n' "$target" "$PWD" >&2
    return 1
  fi

  printf '%s\n' "$found"
  return 0
}

# If script is executed directly, output target directory
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  cdup_find_target "$@"
  exit $?
fi
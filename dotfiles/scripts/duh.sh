#!/bin/bash
# duh: Display disk usage with human-readable output and sorted by size.
# This script can be executed directly or sourced for the duh function.

duh() {
  # Help if no args or -h/--help
  if [[ $# -eq 0 || $1 == '--help' || $1 == '-h' ]]; then
    local duh_cmd="du -a -h --max-depth=1"
    printf '\nUsage: %s [<target_dir>] [<options>]\n' "${0##*/}"
    printf '  Show disk usage of target_dir (default: .) with human-readable sizes.\n'
    printf '  Options are passed to du (e.g., --exclude).\n\n'
    printf 'Examples:\n'
    printf '  %s some_folder --exclude=node_modules --exclude=.git\n' "${0##*/}"
    printf '  %s                    # current dir\n' "${0##*/}"
    return 0
  fi

  # Check dependencies
  command -v du >/dev/null || { printf 'Error: du command not found\n' >&2; return 1; }
  command -v sort >/dev/null || { printf 'Error: sort command not found\n' >&2; return 1; }

  # Parse args: target_dir (defaults to .), rest as params
  local duh_target_dir="."
  if [[ $# -gt 0 ]]; then
    duh_target_dir="$1"
    if [[ ! -d "$duh_target_dir" ]]; then
      printf 'Error: <target_dir> "%s" not found or not a directory\n' "$duh_target_dir" >&2
      return 1
    fi
    shift
  fi
  local duh_param="$@"

  # Prepare command array
  local cmd=(du -a -h --max-depth=1 "$duh_target_dir" $duh_param)

  # Execute and sort; capture output, handle errors
  local duh_output bold normal
  if duh_output=$("${cmd[@]}" 2>&1 | sort -h -r 2>/dev/null); then
    # No bold if not tty
    if [[ -t 1 ]]; then
      bold=$(tput bold 2>/dev/null || echo "")
      normal=$(tput sgr0 2>/dev/null || echo "")
    fi
    local duh_output2=$(printf '%s\n' "$duh_output" | tail -n +2)
    local duh_total=$(printf '%s\n' "$duh_output" | head -n 1)
    printf '%s\n\n===\n%sTotal: %s%s\n' "$duh_output2" "$bold" "$duh_total" "$normal"
  else
    printf 'Error: du command failed\n' >&2
    return 1
  fi
}

# If script is executed directly, show usage or run duh "$@"
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if (( $# == 0 )); then
    duh -h
    exit $?
  else
    duh "$@"
    exit $?
  fi
fi
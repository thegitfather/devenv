function echoerr() { echo "$@" 1>&2; }

# Determine dotfiles directory based on where this file is sourced from
# Works for bash and zsh
if [[ -n "${BASH_SOURCE[0]}" ]]; then
  _DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
elif [[ -n "${ZSH_VERSION}" ]]; then
  # zsh: use %N prompt expansion to get current script path
  _DOTFILES_DIR="$(cd "$(dirname "${0:A}")" 2>/dev/null && pwd)"
fi

# Fallback: try $HOME/dotfiles if we couldn't determine the path
if [[ -z "$_DOTFILES_DIR" || ! -d "$_DOTFILES_DIR/scripts" ]]; then
  if [[ -d "$HOME/dotfiles/scripts" ]]; then
    _DOTFILES_DIR="$HOME/dotfiles"
  else
    echo "Warning: Could not determine dotfiles directory" >&2
  fi
fi

# ignore binary files (grep -I)
grepstring() {
  if [ "$#" -eq "0" ] || [ "$#" -gt 2 ]; then
    echo "Usage: grepstring \"foo\" [\"*.txt\"]";
    echo "Desc: find a string in files in current directory";
  else
    if [ "$#" -eq "1" ]; then
      grep -nriI "$1" . 2>/dev/null
    elif [ "$#" -eq "2" ]; then
      grep -nriI --include "$2" "$1" . 2>/dev/null
    fi
  fi
}

lastmod() {
  "$_DOTFILES_DIR/scripts/lastmod.sh" "$@"
}

gitpreviewpull() {
  if [ "$#" -eq "0" ]; then
    local currentbranch=$(git status | grep "On branch" | cut -c 11-)
    echo "cb: $currentbranch"
    git log --name-only HEAD..origin/"$currentbranch"
  else
    echo "Usage: gitpreviewpull"
  fi
}

cdfind() {
  local target
  target=$("$_DOTFILES_DIR/scripts/cdfind.sh" "$@")
  local ret=$?
  if [[ $ret -eq 0 && -n "$target" && -d "$target" ]]; then
    cd -- "$target"
  fi
  return $ret
}

cdup() {
  local target
  target=$("$_DOTFILES_DIR/scripts/cdup.sh" "$@")
  local ret=$?
  if [[ $ret -eq 0 && -n "$target" && -d "$target" ]]; then
    cd -- "$target"
  fi
  return $ret
}

duh() {
  "$_DOTFILES_DIR/scripts/duh.sh" "$@"
}

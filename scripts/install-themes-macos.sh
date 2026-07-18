#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
ENGINE_ROOT="${CODEX_DREAM_SKIN_ENGINE:-$HOME/.codex/codex-dream-skin-studio}"
ENGINE_SCRIPTS="$ENGINE_ROOT/scripts"
STATE_ROOT="$HOME/Library/Application Support/CodexDreamSkinStudio"
THEMES_ROOT="$STATE_ROOT/themes"
INJECTOR="$ENGINE_SCRIPTS/injector.mjs"
SWITCHER="$ENGINE_SCRIPTS/switch-theme-macos.sh"
NODE="${CODEX_DREAM_SKIN_NODE:-/Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node}"
THEME_ID=""
APPLY_NOW="true"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --id) THEME_ID="${2:-}"; shift 2 ;;
    --no-apply) APPLY_NOW="false"; shift ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done

[ -x "$SWITCHER" ] || { printf 'Theme engine not found: %s\nInstall Codex Dream Skin first.\n' "$ENGINE_ROOT" >&2; exit 1; }
[ -f "$INJECTOR" ] || { printf 'Theme injector not found: %s\n' "$INJECTOR" >&2; exit 1; }
[ -x "$NODE" ] || { printf 'Bundled Node runtime not found: %s\n' "$NODE" >&2; exit 1; }

/bin/mkdir -p "$THEMES_ROOT"

install_one() {
  local source="$1"
  local id="$(basename "$source")"
  local destination="$THEMES_ROOT/$id"
  local temporary="$THEMES_ROOT/.${id}.installing.$$"
  /bin/rm -rf "$temporary"
  /bin/mkdir -p "$temporary"
  /bin/cp "$source/theme.json" "$source/background.jpg" "$temporary/" 2>/dev/null || {
    /bin/rm -rf "$temporary"
    printf 'Theme %s must contain theme.json and background.jpg\n' "$id" >&2
    exit 1
  }
  "$NODE" "$INJECTOR" --check-payload --theme-dir "$temporary" >/dev/null || {
    /bin/rm -rf "$temporary"
    printf 'Theme validation failed: %s\n' "$id" >&2
    exit 1
  }
  /bin/rm -rf "$destination"
  /bin/mv "$temporary" "$destination"
  /bin/chmod 700 "$destination"
  /bin/chmod 600 "$destination"/*
  printf 'Installed %s\n' "$id"
}

found="false"
for source in "$ROOT"/themes/preset-*/; do
  [ -d "$source" ] || continue
  id="$(basename "$source")"
  if [ -n "$THEME_ID" ] && [ "$id" != "$THEME_ID" ]; then
    continue
  fi
  case "$id" in
    preset-[a-z0-9_-]*) ;;
    *) printf 'Invalid theme id: %s\n' "$id" >&2; exit 1 ;;
  esac
  install_one "$source"
  found="true"
done

[ "$found" = "true" ] || { printf 'No matching theme found.\n' >&2; exit 1; }

if [ "$APPLY_NOW" = "true" ] && [ -n "$THEME_ID" ]; then
  "$SWITCHER" --id "$THEME_ID"
elif [ "$APPLY_NOW" = "true" ]; then
  printf 'Themes installed. Use switch-theme-macos.sh --id <theme-id> to apply one.\n'
fi

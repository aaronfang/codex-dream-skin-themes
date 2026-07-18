#!/bin/bash

set -euo pipefail

ENGINE_ROOT="${CODEX_DREAM_SKIN_ENGINE:-$HOME/.codex/codex-dream-skin-studio}"
PLUGIN_SRC="$ENGINE_ROOT/menubar/codex_dream_skin.10s.sh"
STATE_ROOT="$HOME/Library/Application Support/CodexDreamSkinStudio"
PLUGIN_DIR="$STATE_ROOT/menubar"
PLUGIN_DST="$PLUGIN_DIR/codex_dream_skin.10s.sh"

[ -d "/Applications/SwiftBar.app" ] || [ -d "$HOME/Applications/SwiftBar.app" ] || {
  printf 'SwiftBar.app not found. Install it first with:\n\n  brew install --cask swiftbar\n' >&2
  exit 1
}
[ -f "$PLUGIN_SRC" ] || {
  printf 'Codex Dream Skin engine not found: %s\nInstall the engine first.\n' "$ENGINE_ROOT" >&2
  exit 1
}

/bin/mkdir -p "$PLUGIN_DIR"
if ! /usr/bin/cmp -s "$PLUGIN_SRC" "$PLUGIN_DST" 2>/dev/null; then
  /bin/cp -f "$PLUGIN_SRC" "$PLUGIN_DST"
fi
/bin/chmod 755 "$PLUGIN_DST"
/usr/bin/defaults write com.ameba.SwiftBar PluginDirectory -string "$PLUGIN_DIR" 2>/dev/null || true
/usr/bin/open -a "/Applications/SwiftBar.app" 2>/dev/null || /usr/bin/open -a "$HOME/Applications/SwiftBar.app" 2>/dev/null || true
/bin/sleep 1
/usr/bin/open "swiftbar://refreshall" 2>/dev/null || true

printf 'SwiftBar plugin installed.\n'
printf '  Plugin folder: %s\n' "$PLUGIN_DIR"
printf '  Engine: %s\n' "$ENGINE_ROOT"

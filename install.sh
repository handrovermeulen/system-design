#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Check that ~/.claude/ exists
if [ ! -d "$CLAUDE_DIR" ]; then
  echo "Error: $CLAUDE_DIR does not exist. Install Claude Code first."
  exit 1
fi

echo "Installing system-design skill chain..."
echo ""

# 1. Symlink commands
COMMANDS_SRC="$SCRIPT_DIR/.claude/commands/system"
COMMANDS_DST="$CLAUDE_DIR/commands/system"

mkdir -p "$CLAUDE_DIR/commands"

if [ -L "$COMMANDS_DST" ]; then
  rm "$COMMANDS_DST"
elif [ -d "$COMMANDS_DST" ]; then
  echo "Warning: $COMMANDS_DST exists as a directory. Backing up to ${COMMANDS_DST}.bak"
  mv "$COMMANDS_DST" "${COMMANDS_DST}.bak"
fi

ln -s "$COMMANDS_SRC" "$COMMANDS_DST"
echo "  Linked commands:   $COMMANDS_DST -> $COMMANDS_SRC"

# 2. Symlink agent files
AGENTS_SRC_DIR="$SCRIPT_DIR/.claude/agents"
AGENTS_DST_DIR="$CLAUDE_DIR/agents"

mkdir -p "$AGENTS_DST_DIR"

for agent_file in "$AGENTS_SRC_DIR"/sys-*.md; do
  [ -f "$agent_file" ] || continue
  filename="$(basename "$agent_file")"
  dst="$AGENTS_DST_DIR/$filename"

  if [ -L "$dst" ]; then
    rm "$dst"
  fi

  ln -s "$agent_file" "$dst"
  echo "  Linked agent:      $dst -> $agent_file"
done

# 3. Symlink system-design references and templates
SYSDESIGN_SRC="$SCRIPT_DIR/.claude/system-design"
SYSDESIGN_DST="$CLAUDE_DIR/system-design"

if [ -L "$SYSDESIGN_DST" ]; then
  rm "$SYSDESIGN_DST"
elif [ -d "$SYSDESIGN_DST" ]; then
  echo "Warning: $SYSDESIGN_DST exists as a directory. Backing up to ${SYSDESIGN_DST}.bak"
  mv "$SYSDESIGN_DST" "${SYSDESIGN_DST}.bak"
fi

ln -s "$SYSDESIGN_SRC" "$SYSDESIGN_DST"
echo "  Linked references: $SYSDESIGN_DST -> $SYSDESIGN_SRC"

echo ""
echo "Done. Run /system:new-system in any Claude Code project to start."

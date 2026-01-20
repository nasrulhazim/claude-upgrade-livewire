#!/bin/bash

# Livewire 3 to 4 Upgrade Guide Installer
# This script installs the upgrade guide to your ~/.claude directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     Livewire 3 to 4 Upgrade Guide Installer               ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create ~/.claude/commands directory if it doesn't exist
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

echo "Creating directories..."
mkdir -p "$COMMANDS_DIR"

# Copy the upgrade command
echo "Installing /upgrade-livewire command..."
cp "$SCRIPT_DIR/upgrade-livewire.md" "$COMMANDS_DIR/"

# Copy the full guide as reference
echo "Installing upgrade guide reference..."
cp "$SCRIPT_DIR/livewire-upgrade-guide.md" "$CLAUDE_DIR/"

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "Installed files:"
echo "  - $COMMANDS_DIR/upgrade-livewire.md"
echo "  - $CLAUDE_DIR/livewire-upgrade-guide.md"
echo ""
echo "Usage:"
echo "  In any project with Claude Code, type:"
echo "    /upgrade-livewire"
echo ""
echo "  Or reference the full guide:"
echo "    See ~/.claude/livewire-upgrade-guide.md"
echo ""

#!/bin/bash

# Livewire 3 to 4 Upgrade Guide Installer
# Version: 1.0.0
# Usage: curl -fsSL https://raw.githubusercontent.com/nasrulhazim/claude-upgrade-livewire/main/install.sh | bash

set -e

echo "🚀 Installing Livewire 3 to 4 Upgrade Guide"
echo "============================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect installation method
if [ -d ".git" ] && [ -f "upgrade-livewire.md" ]; then
    # Running from cloned repository
    INSTALL_MODE="local"
    REPO_DIR="$(pwd)"
    echo -e "${BLUE}ℹ️  Installing from local repository${NC}"
else
    # Running from curl | bash
    INSTALL_MODE="remote"
    REPO_URL="https://raw.githubusercontent.com/nasrulhazim/claude-upgrade-livewire/main"
    echo -e "${BLUE}ℹ️  Installing from remote repository${NC}"
fi

echo ""

# Check if ~/.claude directory exists
if [ ! -d ~/.claude ]; then
    echo -e "${YELLOW}Creating ~/.claude directory...${NC}"
    mkdir -p ~/.claude
fi

# Check if ~/.claude/commands directory exists
if [ ! -d ~/.claude/commands ]; then
    echo -e "${YELLOW}Creating ~/.claude/commands directory...${NC}"
    mkdir -p ~/.claude/commands
fi

# Function to install file from local or remote
install_file() {
    local source_file=$1
    local dest_file=$2
    local file_desc=$3

    if [ -f "$dest_file" ]; then
        echo -e "${YELLOW}⚠️  $file_desc already exists${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Skipping $file_desc${NC}"
            return 1
        fi
    fi

    if [ "$INSTALL_MODE" = "local" ]; then
        cp "$REPO_DIR/$source_file" "$dest_file"
    else
        curl -fsSL "$REPO_URL/$source_file" -o "$dest_file"
    fi

    if [ -f "$dest_file" ]; then
        echo -e "${GREEN}✓${NC} $file_desc installed"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to install $file_desc"
        return 1
    fi
}

echo "📦 Installing files..."
echo ""

# Install files
install_file "upgrade-livewire.md" ~/.claude/commands/upgrade-livewire.md "Upgrade command"
install_file "livewire-upgrade-guide.md" ~/.claude/livewire-upgrade-guide.md "Upgrade guide reference"

echo ""
echo -e "${GREEN}✅ Livewire 3 to 4 Upgrade Guide installed successfully!${NC}"
echo ""
echo "📖 Usage:"
echo "   /upgrade-livewire               - Start the upgrade process"
echo "   /upgrade-livewire app           - Upgrade a Laravel application"
echo "   /upgrade-livewire package       - Upgrade a Livewire package"
echo ""
echo "📋 Guide Location:"
echo "   ~/.claude/livewire-upgrade-guide.md"
echo ""
echo "🔧 Example Commands:"
echo "   /upgrade-livewire"
echo "   /upgrade-livewire app"
echo "   /upgrade-livewire package"
echo ""
echo "📚 Full README:"
if [ "$INSTALL_MODE" = "local" ]; then
echo "   cat $REPO_DIR/README.md"
else
echo "   https://github.com/nasrulhazim/claude-upgrade-livewire"
fi
echo ""
echo "🎉 You're all set! Try '/upgrade-livewire' in any Livewire project with Claude Code."
echo ""

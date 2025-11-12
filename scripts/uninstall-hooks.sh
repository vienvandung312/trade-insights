#!/bin/bash

# Script to uninstall git hooks for trade-insights project

# Load common utilities (if available, otherwise define minimal colors)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/../.githooks/common.sh" ]; then
    source "$SCRIPT_DIR/../.githooks/common.sh"
else
    # Minimal definitions if common.sh not found
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
    success() { echo -e "${GREEN}✓${NC} $1"; }
    error() { echo -e "${RED}✗${NC} $1"; }
    warning() { echo -e "${YELLOW}⚠${NC} $1"; }
    section() { echo -e "${YELLOW}$1${NC}"; }
fi

section "Uninstalling git hooks..."
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    error "Not in a git repository"
    exit 1
fi

# Remove hooks
removed_count=0
for hook in pre-commit pre-push commit-msg; do
    if [ -f .git/hooks/$hook ]; then
        rm .git/hooks/$hook
        success "Removed $hook"
        removed_count=$((removed_count + 1))
    fi
done

echo ""
if [ $removed_count -gt 0 ]; then
    success "Successfully removed ${removed_count} hook(s)"
else
    warning "No hooks were installed"
fi
echo ""


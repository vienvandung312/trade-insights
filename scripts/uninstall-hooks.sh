#!/bin/bash

# Script to uninstall git hooks for trade-insights project

# Load common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

header "Git Hooks Uninstallation"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    error "Not in a git repository"
    echo "  Please run this script from the project root"
    exit 1
fi

info "Searching for installed hooks..."
echo ""

# Remove hooks
removed_count=0
hooks_to_remove=()

for hook in pre-commit pre-push commit-msg; do
    if [ -f .git/hooks/$hook ]; then
        hooks_to_remove+=("$hook")
    fi
done

if [ ${#hooks_to_remove[@]} -eq 0 ]; then
    warning "No git hooks found to uninstall"
    echo ""
    exit 0
fi

section "Found ${#hooks_to_remove[@]} hook(s) to remove:"
for hook in "${hooks_to_remove[@]}"; do
    echo "  • $hook"
done
echo ""

# Remove each hook
for hook in "${hooks_to_remove[@]}"; do
    rm .git/hooks/$hook
    success "Removed $hook"
    removed_count=$((removed_count + 1))
done

echo ""
header "Uninstallation Complete!"
echo ""
success "Successfully removed ${removed_count} git hook(s)"
echo ""
info "Git hooks are now disabled"
echo "  You can reinstall them anytime by running:"
echo "  ${GREEN}./scripts/install-hooks.sh${NC}"
echo ""


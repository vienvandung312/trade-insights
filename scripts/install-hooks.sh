#!/bin/bash

# Script to install git hooks for trade-insights project

# Load common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

header "Git Hooks Installation Script"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    error "Not in a git repository"
    echo -e "  Please run this script from the project root"
    exit 1
fi

# Check if .githooks directory exists
if [ ! -d .githooks ]; then
    error ".githooks directory not found"
    exit 1
fi

section "This will install the following git hooks:"
echo -e "  • ${GREEN}pre-commit${NC}  - Checks for large files, secrets, and debug statements"
echo -e "  • ${GREEN}pre-push${NC}    - Validates branch naming convention"
echo -e "  • ${GREEN}commit-msg${NC}  - Validates commit message quality"
echo ""

# Check if hooks already exist
existing_hooks=()
for hook in pre-commit pre-push commit-msg; do
    if [ -f .git/hooks/$hook ]; then
        existing_hooks+=($hook)
    fi
done

if [ ${#existing_hooks[@]} -gt 0 ]; then
    warning "The following hooks already exist:"
    for hook in "${existing_hooks[@]}"; do
        echo -e "  • $hook"
    done
    echo ""
    if ! ask_yes_no "Do you want to ${RED}overwrite${NC} them?" "N"; then
        warning "Installation cancelled"
        exit 0
    fi
    echo ""
fi

# Install hooks
section "Installing hooks..."
echo ""

installed_count=0
for hook in pre-commit pre-push commit-msg; do
    if [ -f .githooks/$hook ]; then
        cp .githooks/$hook .git/hooks/$hook
        chmod +x .git/hooks/$hook
        success "Installed $hook"
        installed_count=$((installed_count + 1))
    else
        warning "Hook not found: $hook"
    fi
done

echo ""
header "Installation Complete!"
echo ""
success "Installed ${installed_count} git hook(s)"
echo ""
section "What happens now:"
echo ""
info "Branch Name Validation"
echo "   When you push, branch names must follow:"
echo "   • feature/your-description"
echo "   • bugfix/your-description"
echo "   • hotfix/your-description"
echo ""
info "Commit Message Validation"
echo "   Commit messages must be:"
echo "   • At least 10 characters long"
echo "   • Descriptive (not just 'fix' or 'update')"
echo ""
info "Pre-commit Checks"
echo "   Before committing, checks for:"
echo "   • Large files (>$(human_readable_size $MAX_FILE_SIZE))"
echo "   • Hardcoded secrets/passwords"
echo "   • Debug statements"
echo ""
section "To bypass a hook (use sparingly):"
echo "  git commit --no-verify"
echo "  git push --no-verify"
echo ""
success "Happy coding! 🚀"
echo ""


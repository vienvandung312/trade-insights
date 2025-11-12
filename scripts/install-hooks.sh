#!/bin/bash

# Script to install git hooks for trade-insights project

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Git Hooks Installation Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo -e "${RED}✗ Error: Not in a git repository${NC}"
    echo -e "  Please run this script from the project root"
    exit 1
fi

# Check if .githooks directory exists
if [ ! -d .githooks ]; then
    echo -e "${RED}✗ Error: .githooks directory not found${NC}"
    exit 1
fi

echo -e "${YELLOW}This will install the following git hooks:${NC}"
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
    echo -e "${YELLOW}⚠ Warning: The following hooks already exist:${NC}"
    for hook in "${existing_hooks[@]}"; do
        echo -e "  • $hook"
    done
    echo ""
    echo -e "Do you want to ${RED}overwrite${NC} them? [y/N] "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
    echo ""
fi

# Install hooks
echo -e "${YELLOW}Installing hooks...${NC}"
echo ""

installed_count=0
for hook in pre-commit pre-push commit-msg; do
    if [ -f .githooks/$hook ]; then
        cp .githooks/$hook .git/hooks/$hook
        chmod +x .git/hooks/$hook
        echo -e "${GREEN}✓${NC} Installed $hook"
        installed_count=$((installed_count + 1))
    else
        echo -e "${YELLOW}⚠${NC} Hook not found: $hook"
    fi
done

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Installed ${GREEN}${installed_count}${NC} git hook(s)"
echo ""
echo -e "${YELLOW}What happens now:${NC}"
echo ""
echo -e "${BLUE}1. Branch Name Validation${NC}"
echo -e "   When you push, branch names must follow:"
echo -e "   • feature/your-description"
echo -e "   • bugfix/your-description"
echo -e "   • hotfix/your-description"
echo ""
echo -e "${BLUE}2. Commit Message Validation${NC}"
echo -e "   Commit messages must be:"
echo -e "   • At least 10 characters long"
echo -e "   • Descriptive (not just 'fix' or 'update')"
echo ""
echo -e "${BLUE}3. Pre-commit Checks${NC}"
echo -e "   Before committing, checks for:"
echo -e "   • Large files (>10MB)"
echo -e "   • Hardcoded secrets/passwords"
echo -e "   • Debug statements"
echo ""
echo -e "${YELLOW}To bypass a hook (use sparingly):${NC}"
echo -e "  git commit --no-verify"
echo -e "  git push --no-verify"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""


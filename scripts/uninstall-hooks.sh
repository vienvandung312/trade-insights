#!/bin/bash

# Script to uninstall git hooks for trade-insights project

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Uninstalling git hooks...${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo -e "${RED}✗ Error: Not in a git repository${NC}"
    exit 1
fi

# Remove hooks
removed_count=0
for hook in pre-commit pre-push commit-msg; do
    if [ -f .git/hooks/$hook ]; then
        rm .git/hooks/$hook
        echo -e "${GREEN}✓${NC} Removed $hook"
        removed_count=$((removed_count + 1))
    fi
done

echo ""
if [ $removed_count -gt 0 ]; then
    echo -e "${GREEN}Successfully removed ${removed_count} hook(s)${NC}"
else
    echo -e "${YELLOW}No hooks were installed${NC}"
fi
echo ""


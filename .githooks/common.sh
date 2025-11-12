#!/bin/bash

# Common utilities for git hooks
# Source this file in your hooks: source "$(dirname "$0")/../../.githooks/common.sh"

# ============================================
# COLORS
# ============================================

# Color codes for terminal output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export MAGENTA='\033[0;35m'
export NC='\033[0m' # No Color

# Bold colors
export BOLD_RED='\033[1;31m'
export BOLD_GREEN='\033[1;32m'
export BOLD_YELLOW='\033[1;33m'
export BOLD_BLUE='\033[1;34m'

# ============================================
# HELPER FUNCTIONS
# ============================================

# Print success message
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Print error message
error() {
    echo -e "${RED}✗${NC} $1"
}

# Print warning message
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Print info message
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Print header
header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Print section
section() {
    echo -e "${YELLOW}$1${NC}"
}

# Ask yes/no question
# Returns 0 for yes, 1 for no
ask_yes_no() {
    local prompt="$1"
    local default="${2:-N}"
    
    if [ "$default" = "Y" ] || [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi
    
    echo -ne "$prompt"
    read -r response
    
    if [ -z "$response" ]; then
        response="$default"
    fi
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================
# GIT UTILITIES
# ============================================

# Get current branch name
get_current_branch() {
    git symbolic-ref --short HEAD 2>/dev/null
}

# Check if current branch is main/master
is_main_branch() {
    local branch=$(get_current_branch)
    [ "$branch" = "main" ] || [ "$branch" = "master" ]
}

# Get list of staged files
get_staged_files() {
    git diff --cached --name-only --diff-filter=ACM
}

# Check if a file is staged
is_file_staged() {
    local file="$1"
    git diff --cached --name-only --diff-filter=ACM | grep -q "^$file$"
}

# ============================================
# VALIDATION UTILITIES
# ============================================

# Check if branch name matches valid patterns
validate_branch_name() {
    local branch_name="$1"
    
    local valid_patterns=(
        "^feature/.+"
        "^bugfix/.+"
        "^hotfix/.+"
        "^docs/.+"
        "^refactor/.+"
        "^test/.+"
        "^chore/.+"
        "^release/.+"
    )
    
    for pattern in "${valid_patterns[@]}"; do
        if echo "$branch_name" | grep -qE "$pattern"; then
            return 0
        fi
    done
    
    return 1
}

# Print branch naming guide
print_branch_guide() {
    section "Branch naming convention:"
    echo -e "  ${GREEN}feature/${NC}description   - New features"
    echo -e "  ${GREEN}bugfix/${NC}description    - Bug fixes"
    echo -e "  ${GREEN}hotfix/${NC}description    - Critical production fixes"
    echo -e "  ${GREEN}docs/${NC}description      - Documentation updates"
    echo -e "  ${GREEN}refactor/${NC}description  - Code refactoring"
    echo -e "  ${GREEN}test/${NC}description      - Test updates"
    echo -e "  ${GREEN}chore/${NC}description     - Maintenance tasks"
    echo -e "  ${GREEN}release/${NC}version      - Release branches"
    echo -e ""
    section "Examples:"
    echo -e "  feature/add-momentum-strategy"
    echo -e "  bugfix/fix-calculation-error"
    echo -e "  hotfix/critical-api-fix"
}

# Check for potential secrets in file
contains_secrets() {
    local file="$1"
    
    local secret_patterns=(
        "password\s*=\s*['\"][^'\"]+['\"]"
        "api[_-]?key\s*=\s*['\"][^'\"]+['\"]"
        "secret\s*=\s*['\"][^'\"]+['\"]"
        "token\s*=\s*['\"][^'\"]+['\"]"
        "AKIA[0-9A-Z]{16}"  # AWS Access Key
        "sk_live_[0-9a-zA-Z]{24}"  # Stripe Live Secret Key
    )
    
    for pattern in "${secret_patterns[@]}"; do
        if grep -qiE "$pattern" "$file"; then
            return 0
        fi
    done
    
    return 1
}

# Check for debug statements in file
contains_debug() {
    local file="$1"
    
    local debug_patterns=(
        "console\.log"
        "print\("
        "debugger"
        "binding\.pry"
        "import pdb"
    )
    
    for pattern in "${debug_patterns[@]}"; do
        if grep -qE "$pattern" "$file"; then
            return 0
        fi
    done
    
    return 1
}

# Get human-readable file size
human_readable_size() {
    local bytes=$1
    if command -v numfmt &> /dev/null; then
        numfmt --to=iec-i --suffix=B "$bytes"
    else
        # Fallback for systems without numfmt
        if [ $bytes -lt 1024 ]; then
            echo "${bytes}B"
        elif [ $bytes -lt 1048576 ]; then
            echo "$((bytes / 1024))KB"
        elif [ $bytes -lt 1073741824 ]; then
            echo "$((bytes / 1048576))MB"
        else
            echo "$((bytes / 1073741824))GB"
        fi
    fi
}

# ============================================
# CONSTANTS
# ============================================

# File size limit (10MB in bytes)
export MAX_FILE_SIZE=$((10 * 1024 * 1024))

# Minimum commit message length
export MIN_COMMIT_MSG_LENGTH=10

# Generic commit message patterns (to warn against)
export GENERIC_COMMIT_PATTERNS="^(wip|test|fix|update|changes?)$"


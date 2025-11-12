# Using the Common Bash Library

The `.githooks/common.sh` file provides reusable utilities for all git hooks, promoting DRY (Don't Repeat Yourself) principles.

## 📚 Contents

### Colors
Pre-defined color variables for consistent terminal output:
- `$RED`, `$GREEN`, `$YELLOW`, `$BLUE`, `$CYAN`, `$MAGENTA`
- `$BOLD_RED`, `$BOLD_GREEN`, `$BOLD_YELLOW`, `$BOLD_BLUE`
- `$NC` (No Color - resets formatting)

### Helper Functions
- `success "message"` - Print success message with ✓
- `error "message"` - Print error message with ✗
- `warning "message"` - Print warning message with ⚠
- `info "message"` - Print info message with ℹ
- `header "text"` - Print formatted header
- `section "text"` - Print section title
- `ask_yes_no "prompt" [default]` - Ask yes/no question (returns 0 for yes, 1 for no)

### Git Utilities
- `get_current_branch` - Get the current git branch name
- `is_main_branch` - Check if on main/master branch (returns 0 if true)
- `get_staged_files` - Get list of staged files
- `is_file_staged "file"` - Check if specific file is staged

### Validation Utilities
- `validate_branch_name "branch"` - Validate branch name against patterns
- `print_branch_guide` - Print branch naming convention guide
- `contains_secrets "file"` - Check if file contains hardcoded secrets
- `contains_debug "file"` - Check if file contains debug statements
- `human_readable_size bytes` - Convert bytes to human-readable format

### Constants
- `$MAX_FILE_SIZE` - Maximum allowed file size (10MB)
- `$MIN_COMMIT_MSG_LENGTH` - Minimum commit message length (10 chars)
- `$GENERIC_COMMIT_PATTERNS` - Regex for generic commit messages

## 💡 Usage Examples

### In a Git Hook

```bash
#!/bin/bash

# Load common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/.githooks/common.sh"

# Use functions
current_branch=$(get_current_branch)

if is_main_branch; then
    success "On main branch"
    exit 0
fi

if validate_branch_name "$current_branch"; then
    success "Valid branch name"
else
    error "Invalid branch name: $current_branch"
    print_branch_guide
    exit 1
fi
```

### In a Custom Script

```bash
#!/bin/bash

# Load common utilities
source "$(dirname "$0")/../.githooks/common.sh"

# Use colors
echo -e "${GREEN}Success!${NC}"
echo -e "${RED}Error occurred${NC}"
echo -e "${YELLOW}Warning: something to note${NC}"

# Use helper functions
success "Operation completed"
error "Failed to process"
warning "This is deprecated"
info "Here's some information"

# Ask for confirmation
if ask_yes_no "Continue with the operation?" "Y"; then
    success "User confirmed"
else
    error "User cancelled"
fi

# Create sections
header "My Script Title"
section "Step 1: Processing"
echo "  Doing something..."
success "Step 1 complete"

section "Step 2: Validation"
echo "  Checking files..."
success "Step 2 complete"
```

### Working with Files

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

# Check each staged file
get_staged_files | while read -r file; do
    if [ -f "$file" ]; then
        file_size=$(wc -c < "$file")
        
        if [ "$file_size" -gt "$MAX_FILE_SIZE" ]; then
            error "File too large: $file ($(human_readable_size $file_size))"
        fi
        
        if contains_secrets "$file"; then
            error "Secrets detected in: $file"
        fi
        
        if contains_debug "$file"; then
            warning "Debug statements in: $file"
        fi
    fi
done
```

### Creating Custom Validations

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

# Custom validation function
validate_file_extension() {
    local file="$1"
    local allowed_extensions=("py" "js" "ts" "sh")
    
    local extension="${file##*.}"
    
    for ext in "${allowed_extensions[@]}"; do
        if [ "$extension" = "$ext" ]; then
            return 0
        fi
    done
    
    return 1
}

# Use it
get_staged_files | while read -r file; do
    if ! validate_file_extension "$file"; then
        error "Invalid file extension: $file"
        exit 1
    fi
done

success "All files have valid extensions"
```

## 🎨 Color Usage Examples

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

# Basic colors
echo -e "${RED}This is red text${NC}"
echo -e "${GREEN}This is green text${NC}"
echo -e "${YELLOW}This is yellow text${NC}"
echo -e "${BLUE}This is blue text${NC}"

# Bold colors
echo -e "${BOLD_RED}This is bold red${NC}"
echo -e "${BOLD_GREEN}This is bold green${NC}"

# Combining colors
echo -e "${YELLOW}Warning:${NC} ${RED}Error occurred${NC}"
echo -e "${GREEN}Success:${NC} Operation completed in ${BLUE}2.5s${NC}"

# With icons
echo -e "${GREEN}✓${NC} Test passed"
echo -e "${RED}✗${NC} Test failed"
echo -e "${YELLOW}⚠${NC} Warning message"
echo -e "${BLUE}ℹ${NC} Info message"
```

## 🔧 Adding New Functions

To extend the common library:

1. **Add your function to `common.sh`:**

```bash
# In .githooks/common.sh

# Check if file is a Python file
is_python_file() {
    local file="$1"
    [[ "$file" =~ \.py$ ]]
}

# Count lines in staged files
count_staged_lines() {
    local total=0
    get_staged_files | while read -r file; do
        if [ -f "$file" ]; then
            lines=$(wc -l < "$file")
            total=$((total + lines))
        fi
    done
    echo "$total"
}
```

2. **Use it in your hooks:**

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

if is_python_file "script.py"; then
    info "Processing Python file"
fi

total=$(count_staged_lines)
info "Total lines being committed: $total"
```

## 📝 Best Practices

### 1. Always Reset Colors

```bash
# Good
echo -e "${GREEN}Success${NC}"

# Bad - color bleeds to next line
echo -e "${GREEN}Success"
```

### 2. Use Helper Functions

```bash
# Good - consistent formatting
success "Operation complete"

# Less good - manual formatting
echo -e "${GREEN}✓${NC} Operation complete"
```

### 3. Check File Existence

```bash
# Good
if [ -f "$file" ]; then
    if contains_secrets "$file"; then
        error "Secrets detected"
    fi
fi

# Bad - may fail on non-existent files
if contains_secrets "$file"; then
    error "Secrets detected"
fi
```

### 4. Exit Codes

```bash
# Functions that check conditions should return 0 for true, 1 for false
if validate_branch_name "$branch"; then
    success "Valid branch"
else
    error "Invalid branch"
fi
```

## 🚀 Advanced Examples

### Creating a Custom Pre-Push Hook

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

header "Running Custom Pre-Push Checks"

# Check 1: Branch name
current_branch=$(get_current_branch)
if ! is_main_branch && ! validate_branch_name "$current_branch"; then
    error "Invalid branch name: $current_branch"
    print_branch_guide
    exit 1
fi
success "Branch name valid"

# Check 2: Ensure tests pass
section "Running tests..."
if npm test > /dev/null 2>&1; then
    success "All tests passed"
else
    error "Tests failed - fix before pushing"
    exit 1
fi

# Check 3: Check for TODO comments
section "Checking for TODOs..."
if git diff origin/main...HEAD | grep -q "TODO"; then
    warning "Found TODO comments in diff"
    if ! ask_yes_no "Continue anyway?"; then
        exit 1
    fi
fi

success "All pre-push checks passed!"
```

### Creating a Progress Indicator

```bash
#!/bin/bash
source "$(dirname "$0")/../.githooks/common.sh"

tasks=("Linting" "Testing" "Building" "Deploying")
total=${#tasks[@]}

for i in "${!tasks[@]}"; do
    task="${tasks[$i]}"
    current=$((i + 1))
    
    section "[$current/$total] $task..."
    sleep 1  # Simulate work
    success "$task complete"
done

success "All tasks completed!"
```

## 📖 Reference

For the complete list of available functions and their implementations, see [`common.sh`](./common.sh).

For usage in actual git hooks, see:
- [`pre-commit`](./pre-commit) - File size, secrets, debug checks
- [`pre-push`](./pre-push) - Branch name validation
- [`commit-msg`](./commit-msg) - Commit message quality

## 🤝 Contributing

When adding new utility functions:
1. Keep them generic and reusable
2. Add comments explaining parameters and return values
3. Follow existing naming conventions
4. Update this documentation
5. Test with all existing hooks


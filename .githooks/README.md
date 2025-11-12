# Git Hooks for trade-insights

This directory contains git hooks to enforce code quality and branching strategies for the trade-insights project.

## 🎯 Purpose

Git hooks automatically run checks at various points in your git workflow to:
- Enforce branch naming conventions
- Validate commit message quality
- Prevent committing secrets or large files
- Maintain code quality standards

## 🚀 Installation

### Quick Install

From the project root, run:

```bash
./scripts/install-hooks.sh
```

This will install all hooks into your `.git/hooks` directory.

### Manual Install

If you prefer to install hooks manually:

```bash
# Copy hooks to .git/hooks/
cp .githooks/pre-commit .git/hooks/
cp .githooks/pre-push .git/hooks/
cp .githooks/commit-msg .git/hooks/

# Make them executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
chmod +x .git/hooks/commit-msg
```

## 📋 Available Hooks

### 1. **pre-push** - Branch Name Validation

Runs before `git push` to validate branch naming convention.

**Enforces these patterns:**
```
✅ feature/description      - New features
✅ bugfix/description       - Bug fixes
✅ hotfix/description       - Critical production fixes
✅ docs/description         - Documentation updates
✅ refactor/description     - Code refactoring
✅ test/description         - Test updates
✅ chore/description        - Maintenance tasks
✅ release/version          - Release branches
```

**Example:**
```bash
# ✅ Valid - will push successfully
git checkout -b feature/add-momentum-strategy
git push

# ❌ Invalid - will be rejected
git checkout -b my-feature
git push
# Error: Invalid branch name
```

**To fix:**
```bash
# Rename your branch to follow convention
git branch -m my-feature feature/add-momentum-strategy
git push
```

### 2. **commit-msg** - Commit Message Validation

Runs when writing a commit message to ensure quality.

**Checks:**
- ✅ Minimum 10 characters
- ⚠️  Warns on generic messages ("fix", "update", "wip")
- ✅ Allows descriptive messages

**Example:**
```bash
# ❌ Too short
git commit -m "fix"
# Error: Commit message too short

# ⚠️  Generic (shows warning)
git commit -m "update"
# Warning: Generic commit message

# ✅ Good
git commit -m "Add momentum-based trading strategy with MA crossover"
```

### 3. **pre-commit** - Pre-Commit Checks

Runs before `git commit` to catch common issues.

**Checks for:**
- 🚫 Large files (> 10MB)
- 🔐 Hardcoded secrets (passwords, API keys, tokens)
- 🐛 Debug statements (console.log, print, debugger)

**Example:**
```bash
# ❌ Large file detected
git add large_dataset.csv  # 50MB file
git commit -m "Add dataset"
# Error: Large files detected

# ❌ Secret detected
# In config.py: API_KEY = "sk_live_abc123..."
git add config.py
git commit -m "Add config"
# Error: Potential secrets detected

# ⚠️  Debug statement warning
# In code: console.log("debugging...")
git add app.js
git commit -m "Add feature"
# Warning: Debug statements detected
```

## 🔧 Configuration

### Customizing Branch Patterns

Edit `.githooks/pre-push` and modify the `valid_patterns` array:

```bash
valid_patterns=(
    "^feature/.+"
    "^bugfix/.+"
    # Add your custom pattern here
    "^experimental/.+"
)
```

### Adjusting File Size Limit

Edit `.githooks/pre-commit` and change the `max_file_size`:

```bash
# Change from 10MB to 50MB
max_file_size=$((50 * 1024 * 1024))
```

### Disabling Specific Checks

Comment out sections you don't want in the hook files:

```bash
# To disable debug statement check in pre-commit
# Comment out the "Check for debug statements" section
```

## ⚠️ Bypassing Hooks

Sometimes you need to bypass hooks (use sparingly!):

```bash
# Bypass all hooks for this commit
git commit --no-verify -m "Emergency fix"

# Bypass all hooks for this push
git push --no-verify
```

**When to bypass:**
- ✅ Emergency hotfixes
- ✅ Intentional large file commits (after consideration)
- ❌ To avoid fixing legitimate issues (don't do this!)

## 🗑️ Uninstallation

To remove all git hooks:

```bash
./scripts/uninstall-hooks.sh
```

Or manually:

```bash
rm .git/hooks/pre-commit
rm .git/hooks/pre-push
rm .git/hooks/commit-msg
```

## 🤝 Team Setup

When a new team member joins:

1. Clone the repository
2. Run the installation script:
   ```bash
   ./scripts/install-hooks.sh
   ```
3. Start coding with enforced standards!

## 📝 Best Practices

### Branch Naming

✅ **Good:**
```
feature/add-rsi-indicator
bugfix/fix-price-calculation
hotfix/critical-memory-leak
```

❌ **Bad:**
```
my-branch
johns-work
temp
```

### Commit Messages

✅ **Good:**
```
Add RSI indicator to trading strategy
Fix off-by-one error in profit calculation
Refactor data pipeline for better performance
```

❌ **Bad:**
```
fix
update
wip
changes
```

## 🐛 Troubleshooting

### Hooks not running?

Check if they're executable:
```bash
ls -la .git/hooks/
# Should show: -rwxr-xr-x

# If not, make them executable:
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
chmod +x .git/hooks/commit-msg
```

### Hook failing incorrectly?

The hooks are bash scripts - you can edit them directly in `.git/hooks/` or update the source in `.githooks/` and reinstall.

### Want to temporarily disable all hooks?

```bash
# Disable
mv .git/hooks .git/hooks.disabled

# Re-enable
mv .git/hooks.disabled .git/hooks
```

## 📚 Additional Resources

- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)

## 🎉 Summary

Once installed, these hooks will:
- ✅ Keep your branch names consistent
- ✅ Improve commit message quality
- ✅ Prevent accidental secret commits
- ✅ Block large files from being committed
- ✅ Remind you to remove debug statements

They run automatically - no extra steps needed!


# Trade Insights

A project for trade insights and analysis.

## Getting Started

This project is currently under development.

## Development Setup

### Git Hooks Installation

This project uses git hooks to enforce code quality and branching strategies. To install them:

```bash
./scripts/install-hooks.sh
```

**What the hooks do:**
- ✅ Enforce branch naming conventions (`feature/`, `bugfix/`, `hotfix/`, etc.)
- ✅ Validate commit message quality (minimum length, descriptive)
- ✅ Prevent committing secrets (API keys, passwords)
- ✅ Block large files (> 10MB)
- ✅ Warn about debug statements

For more details, see [.githooks/README.md](.githooks/README.md)

### Branch Naming Convention

Follow these patterns:
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical production fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test updates


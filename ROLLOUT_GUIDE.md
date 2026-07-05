# CLI Cache Rollout Monitoring Guide

## Overview

This guide covers monitoring the `cli-cache.json` updates that are pushed by the npm CLI bot.

## What is cli-cache.json?

The `cli-cache.json` file contains commit hashes for different CLI versions:
- **v8**, **v9**, **v10**, **v11** — Major version commit references
- Used by documentation build system to fetch correct CLI documentation

## Monitoring Setup

### 1. Automated Validation
- **File:** `.github/workflows/monitor-cli-cache.yml`
- **Trigger:** Any push to `cli-cache.json` on main branch
- **Checks:**
  - ✅ Cache format validation (valid SHA hashes)
  - ✅ Deployment tracking (creates monitoring issue)
  - ✅ Build simulation

### 2. Cache Validation Script
- **File:** `scripts/validate-cli-cache.js`
- **Run locally:** `node scripts/validate-cli-cache.js`
- **Use in CI:** Add to pre-commit hooks

### 3. Regression Detection
- **File:** `.github/workflows/detect-cache-issues.yml`
- **Trigger:** Runs every 30 minutes
- **Checks:**
  - Recent build failures
  - Regression-labeled issues
  - CLI v11-related issues

### 4. Rollback Script
- **File:** `scripts/rollback-cli-cache.sh`
- **Usage:** `./scripts/rollback-cli-cache.sh <commit-sha>`
- **Example:** `./scripts/rollback-cli-cache.sh 76d28ec40b455545c8f1c81495b55274016594f4`

## Monitoring Checklist

After each CLI cache update:

- [ ] **Check validation passed** — Look for ✅ in workflow runs
- [ ] **Review created issue** — Check monitoring issue for cache status
- [ ] **Monitor build runs** — Watch Actions tab for failures
- [ ] **Check error rate** — No spike in documentation build errors
- [ ] **User reports** — No new regression issues filed
- [ ] **Wait 1 hour** — Allow time for CDN/caches to sync

## If Issues Are Detected

### Quick Rollback
```bash
# Get the failing commit SHA
git log --oneline cli-cache.json | head -5

# Rollback (example with commit from initial issue)
./scripts/rollback-cli-cache.sh 76d28ec40b455545c8f1c81495b55274016594f4

# Push rollback
git push origin HEAD
```

### Escalation
1. Create issue with label `urgent-rollback`
2. Mention `@npm-cli-bot` to investigate
3. Link to any regression reports

## Recent Updates

### Latest Change: 2026-06-26
- **v11 hash updated:** `ca923237...` → `ae6dbeb12...`
- **Status:** ✅ Monitoring in place
- **Issue:** #1 (auto-created)

## Useful Links

- [CLI Cache Commits](https://github.com/paymentalipay83-prog/documentation/commits/main/cli-cache.json)
- [Workflow Runs](https://github.com/paymentalipay83-prog/documentation/actions)
- [Regression Issues](https://github.com/paymentalipay83-prog/documentation/issues?q=label%3Aregression)

## Questions?

For issues with monitoring setup, file an issue with label `monitoring`.

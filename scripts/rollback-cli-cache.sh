#!/bin/bash

# Rollback CLI cache to previous version
# Usage: ./scripts/rollback-cli-cache.sh <commit-sha>

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <commit-sha>"
  echo "Example: $0 76d28ec40b455545c8f1c81495b55274016594f4"
  exit 1
fi

COMMIT=$1

echo "🔄 Rolling back CLI cache from commit $COMMIT..."
echo ""

if ! git show "$COMMIT" -- cli-cache.json > /dev/null 2>&1; then
  echo "❌ Commit $COMMIT does not modify cli-cache.json"
  exit 1
fi

echo "📋 Changes to revert:"
git show "$COMMIT" -- cli-cache.json | head -20

echo ""
echo "⚠️  Creating rollback commit..."
git revert "$COMMIT" --no-edit || {
  echo "❌ Rollback failed. Manual intervention required."
  exit 1
}

echo "✅ Rollback commit created"
echo "📤 Push with: git push origin HEAD"

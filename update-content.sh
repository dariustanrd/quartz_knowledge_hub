#!/bin/bash

# Helper script to update content submodule and commit
# Usage: ./update-content.sh [commit-message]

set -e

COMMIT_MSG="${1:-Update content submodule}"

echo "Updating content submodule..."
git submodule update --remote content

if git diff --quiet content; then
    echo "Content is already up to date!"
    exit 0
fi

echo "Content updated. Staging changes..."
git add content

echo "Committing changes..."
git commit -m "$COMMIT_MSG"

echo ""
echo "✅ Content submodule updated and committed!"
echo "📤 Run 'git push' to push changes to GitHub"
echo ""
echo "To push now, run:"
echo "  git push"

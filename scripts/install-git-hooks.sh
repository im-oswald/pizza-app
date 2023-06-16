#!/bin/bash

set -e

echo "Installing hooks..."

# Pre-Commit Hook
echo "=> Installing pre-commit hook..."
mkdir -p .git/hooks && cp lib/hooks/pre-commit .git/hooks

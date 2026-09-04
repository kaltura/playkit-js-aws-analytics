#!/usr/bin/env bash
# Cuts a release: bumps version, builds dist/, commits both, tags.
# jsDelivr serves this plugin straight from GitHub tags (no npm registry
# involved), so dist/ must be committed at the tagged commit.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash changes before releasing." >&2
  exit 1
fi

npx standard-version --skip.commit --skip.tag

npm run build

VERSION="v$(node -p "require('./package.json').version")"

git add -f dist package.json package-lock.json CHANGELOG.md
git commit -m "chore(release): ${VERSION}"
git tag "${VERSION}"

echo "Release ${VERSION} committed and tagged locally."
echo "Push with: git push && git push --tags"

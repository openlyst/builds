#!/usr/bin/env bash
set -euo pipefail

build_name() {
  local name
  if name=$(date -u +%Y.%-m.%-d 2>/dev/null); then
    printf '%s' "$name"
  else
    date -u +%Y.%m.%d | sed -E 's/\.0([1-9])/\.\1/g; s/\.0([1-9])/\.\1/g'
  fi
}

BUILD_NAME="${BUILD_NAME:-$(build_name)}"
BUILD_NUMBER="${BUILD_NUMBER:-${GITHUB_RUN_NUMBER:-0}}"
BUILD_DATE="${BUILD_DATE:-$(date -u +%Y-%m-%d)}"
GENERATED_AT="${GENERATED_AT:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
RELEASE_TAG="${RELEASE_TAG:-build-${BUILD_NUMBER}}"
COMMIT_SHA="${COMMIT_SHA:-${GITHUB_SHA:-}}"
SOURCE_REPO="${SOURCE_REPO:-${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-}}"
if [[ -n "$COMMIT_SHA" && -n "$SOURCE_REPO" ]]; then
  SOURCE_COMMIT_URL="${SOURCE_REPO%/}/commit/${COMMIT_SHA}"
else
  SOURCE_COMMIT_URL=""
fi

if [[ "${1:-}" == "--github-output" ]]; then
  out="${GITHUB_OUTPUT:?GITHUB_OUTPUT not set}"
  {
    echo "build_name=$BUILD_NAME"
    echo "version=$BUILD_NAME"
    echo "build_number=$BUILD_NUMBER"
    echo "build_date=$BUILD_DATE"
    echo "generated_at=$GENERATED_AT"
    echo "release_tag=$RELEASE_TAG"
    echo "commit_sha=$COMMIT_SHA"
    echo "source_repo=$SOURCE_REPO"
    echo "source_commit_url=$SOURCE_COMMIT_URL"
  } >> "$out"
  exit 0
fi

cat <<JSON
{
  "build_name": "$BUILD_NAME",
  "build_number": "$BUILD_NUMBER",
  "build_date": "$BUILD_DATE",
  "generated_at": "$GENERATED_AT",
  "release_tag": "$RELEASE_TAG",
  "commit_sha": "$COMMIT_SHA",
  "source_repo": "$SOURCE_REPO",
  "source_commit_url": "$SOURCE_COMMIT_URL"
}
JSON

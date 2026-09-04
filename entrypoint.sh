#!/usr/bin/env bash

set -euo pipefail

FEATURE=${1:-}
BASE=${2:-}
TOKEN=${3:-}

if [[ -z "${FEATURE}" ]]; then
  echo "Missing \$FEATURE"
  exit 1
fi

if [[ -z "${BASE}" ]]; then
  echo "Missing \$BASE"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "Missing \$TOKEN"
  exit 1
fi

if [[ -z "${GITHUB_REPOSITORY:-}" ]]; then
  echo "Missing \$GITHUB_REPOSITORY"
  exit 1
fi

remote_url="https://x-access-token:${TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

export GIT_TERMINAL_PROMPT=0

cd $workdir

git init

git remote add origin "https://${GITHUB_ACTOR}:${TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git remote -v
git remote update

# checkout branches to make sure they exists
git checkout "${FEATURE}" --
git checkout "${BASE}" --

if ! git merge-base --is-ancestor "${BASE}" "${FEATURE}"; then
  echo "Feature branch ${FEATURE} is not based on ${BASE}."
  exit 1
fi

MERGE_COMMITS=$(git rev-list --count --min-parents=2 "${BASE}".."${FEATURE}")
if [ $MERGE_COMMITS -gt 0 ]; then
    echo "Feature branch contains $MERGE_COMMITS merge commits, please rebase it against base branch."
    exit 1
fi

echo "Feature branch ${FEATURE} is based on ${BASE}."
exit 0


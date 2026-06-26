#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"
PACKAGE_URL="https://github.com/MapMindAI/UniLidar-SDK-Mapping/releases/download/v0/mapping.tar.gz"

if [[ $# -gt 0 ]]; then
  echo "unexpected arguments: $*" >&2
  echo "usage: $0" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not found" >&2
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "tar not found" >&2
  exit 1
fi

TMP_ARCHIVE="$(mktemp "${TMPDIR:-/tmp}/mapping.XXXXXX.tar.gz")"
cleanup() {
  rm -f "${TMP_ARCHIVE}"
}
trap cleanup EXIT

echo "Downloading package:"
echo "  url=${PACKAGE_URL}"
echo "  archive=${TMP_ARCHIVE}"
curl -fsSL "${PACKAGE_URL}" -o "${TMP_ARCHIVE}"

mkdir -p "${REPO_ROOT}/mapping"
echo "Extracting package into ${REPO_ROOT}/mapping"
tar -xzf "${TMP_ARCHIVE}" -C "${REPO_ROOT}/mapping"

echo "Package extracted to ${REPO_ROOT}/mapping"

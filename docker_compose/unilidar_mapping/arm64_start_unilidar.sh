#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    COMPOSE_NAME="unilidar_mapping"
else
    COMPOSE_NAME=$1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-unilidar}"
COMPOSE_FILE_PATH="${COMPOSE_FILE_PATH:-${REPO_ROOT}/docker_compose/unilidar_mapping/${COMPOSE_NAME}.compose.yml}"
MAPPING_PACKAGE_DIR="${MAPPING_PACKAGE_DIR:-${REPO_ROOT}/mapping}"
DOWNLOAD_SCRIPT="${REPO_ROOT}/download_arm64_app_package.sh"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found" >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "docker compose not available" >&2
  exit 1
fi

if [[ ! -f "${COMPOSE_FILE_PATH}" ]]; then
  echo "compose file not found: ${COMPOSE_FILE_PATH}" >&2
  exit 1
fi

if [[ ! -d "${MAPPING_PACKAGE_DIR}" ]]; then
  if [[ ! -x "${DOWNLOAD_SCRIPT}" ]]; then
    echo "mapping package directory not found: ${MAPPING_PACKAGE_DIR}" >&2
    echo "download script not found or not executable: ${DOWNLOAD_SCRIPT}" >&2
    exit 1
  fi

  echo "mapping package directory not found: ${MAPPING_PACKAGE_DIR}"
  echo "downloading mapping package with ${DOWNLOAD_SCRIPT}"
  "${DOWNLOAD_SCRIPT}"
fi

if [[ ! -d "${MAPPING_PACKAGE_DIR}" ]]; then
  echo "mapping package directory still not found after download: ${MAPPING_PACKAGE_DIR}" >&2
  exit 1
fi

export MAPPING_PACKAGE_DIR

docker compose \
  -p "${COMPOSE_PROJECT_NAME}" \
  -f "${COMPOSE_FILE_PATH}" \
  up -d --force-recreate

echo "docker compose started:"
echo "  project=${COMPOSE_PROJECT_NAME}"
echo "  compose_file=${COMPOSE_FILE_PATH}"
echo "  mapping_package_dir=${MAPPING_PACKAGE_DIR}"

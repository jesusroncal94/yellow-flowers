#!/usr/bin/env bash
# The one check agents and CI run before calling a change done.
# Smoke check: the inline JavaScript of the source page and both exports must parse (Node runs in Docker).
set -euo pipefail
cd "$(dirname "$0")/.."

MSYS_NO_PATHCONV=1 docker run --rm -v "$PWD:/repo:ro" node:22-alpine node /repo/scripts/check-inline-js.js

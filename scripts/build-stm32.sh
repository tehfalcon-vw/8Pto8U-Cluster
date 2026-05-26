#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEST="${WEST:-$ROOT/.venv/bin/west}"

cd "$ROOT/zephyr-workspace"
export ZEPHYR_BASE="$ROOT/zephyr-workspace/zephyr"
export ZEPHYR_TOOLCHAIN_VARIANT="${ZEPHYR_TOOLCHAIN_VARIANT:-gnuarmemb}"
export GNUARMEMB_TOOLCHAIN_PATH="${GNUARMEMB_TOOLCHAIN_PATH:-/opt/homebrew}"

"$WEST" build -b nucleo_c542rc "$ROOT/can_sniff_inject" --build-dir "$ROOT/build/can_sniff_inject"

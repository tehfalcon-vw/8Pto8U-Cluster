#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/build/can_sniff_inject/zephyr/zephyr.bin"

if [[ ! -f "$BIN" ]]; then
  echo "Missing $BIN. Run stm32/scripts/build-stm32.sh first." >&2
  exit 1
fi

volume="${1:-}"
if [[ -z "$volume" ]]; then
  volume="$(find /Volumes -maxdepth 1 -type d | grep -Ei '/(NODE|NUCLEO|DIS_|ST|MBED)' | head -1 || true)"
fi

if [[ -z "$volume" || ! -d "$volume" ]]; then
  echo "Could not find an ST-LINK mass-storage volume under /Volumes." >&2
  echo "Pass it explicitly, e.g. $0 /Volumes/NODE_C542RC" >&2
  exit 1
fi

cp "$BIN" "$volume/"
sync
echo "Copied $(basename "$BIN") to $volume"

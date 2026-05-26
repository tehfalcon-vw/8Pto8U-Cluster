#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${1:-}"

if [[ -z "$PORT" ]]; then
  PORT="$(ls /dev/cu.* 2>/dev/null | grep -Ei 'usb|modem|serial' | head -1 || true)"
fi

if [[ -z "$PORT" ]]; then
  echo "No serial port found. Replug the Nucleo ST-LINK USB cable and retry." >&2
  exit 1
fi

"$ROOT/.venv/bin/python" -m serial.tools.miniterm "$PORT" 115200

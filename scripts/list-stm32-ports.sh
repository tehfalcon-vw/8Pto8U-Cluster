#!/usr/bin/env bash
set -euo pipefail

ls /dev/cu.* 2>/dev/null | grep -Ei 'usb|modem|serial' || true
echo
echo "Volumes:"
find /Volumes -maxdepth 1 -type d | grep -Ei '/(NODE|NUCLEO|DIS_|ST|MBED)' || true

# STM32 8Pto8U Translator

Target: `NUCLEO-C542RC`

Default mode:

- Classic CAN, 100000 bit/s
- Onboard FDCAN transceiver on CN18
- Translation enabled at boot
- A3 comfort status heartbeat enabled at boot
- Live sniff printing disabled at boot
- Serial sniff output uses an SLCAN-like form:
  - `C:t1238...` for standard IDs
  - `C:T000001238...` for extended IDs

Current production mappings:

| A3 8P stalk input | 8U Q3 cluster output |
| --- | --- |
| `0x5C1 22000001` short up press | `0x5BF 06000111` up |
| `0x5C1 23000001` short down press | `0x5BF 06000F11` down |
| `0x5C1 28000001` short OK press | `0x5BF 07000111` OK |
| `0x5C1 22000001` held up press | `0x5BF 03000111` left |
| `0x5C1 23000001` held down press | `0x5BF 02000111` right |
| `0x5C1 28000001` held OK press | `0x5BF 01000111` menu |

Each cluster command is followed by the required release frame:
`0x5BF 00000011`.

8P comfort compatibility:

- `0x551 03` is transmitted every 500 ms. This fixes window and sunroof
  operation with the Q3 cluster installed in the A3 8P.

Press handling:

- Short actions are sent when the stalk returns to neutral with
  `0x5C1 00000001`.
- Hold actions are sent once after about 650 ms.
- If a stalk release frame is missed, the active press state is cleared after
  about 1 second of no matching stalk repeat frames.

Serial commands:

- `stats`
- `sniff on`
- `sniff off`
- `translate on`
- `translate off`
- `send <std-id-hex> <data-hex>`

Example:

```text
send 5BF 07000111
```

Build:

```sh
../scripts/build-stm32.sh
```

Flash:

```sh
../.venv/bin/pyocd flash -t STM32C542RCT6 ../build/can_sniff_inject/zephyr/zephyr.hex
```

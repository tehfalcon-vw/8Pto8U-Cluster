# 8Pto8U Translator

Zephyr firmware for an STM32 Nucleo-C542RC that helps an Audi A3 8P work with
an Audi 8U Q3 instrument cluster.

This firmware does two jobs on 100 kbit/s comfort CAN:

- Translates A3 8P wiper stalk MFD/DIS controls into 8U Q3 cluster MFD/DIS controls.
- Transmits the A3 comfort can status heartbeat needed for window and sunroof
  operation with the 8U cluster installed.

## Hardware

- STM32 Nucleo-C542RC
- 5V Buck Converter

## Installation

Connect STM32 CanH/CANL at CANBUS Gateway (J533) on Comfort CAN. 

Connect fused 12v Power to 5v Buck Converter to Terminal 15 (ign) power source, then 5v buck converter to the STM32.

Stable Firmware to Flash to the STM32 is located on the releases page.

## CAN Behavior

Translation starts enabled at boot. Live sniff logging starts disabled so serial
printing does not add unnecessary load while driving the cluster.

### Stalk To Cluster

| A3 8P stalk input | 8U Q3 cluster output |
| --- | --- |
| `0x5C1 22000001` short up press | `0x5BF 06000111` up |
| `0x5C1 23000001` short down press | `0x5BF 06000F11` down |
| `0x5C1 28000001` short OK press | `0x5BF 07000111` OK |
| `0x5C1 22000001` held up press | `0x5BF 03000111` left |
| `0x5C1 23000001` held down press | `0x5BF 02000111` right |
| `0x5C1 28000001` held OK press | `0x5BF 01000111` menu |

Each translated cluster command is followed by release:

```text
0x5BF 00000011
```

### Comfort Heartbeat

The firmware transmits this frame every 500 ms:

```text
0x551 03
```

This allows A3 8P window and sunroof operation (and other comfort can operations) when the 8U Q3 cluster is
installed.

## Serial Commands

Connect to the ST-LINK virtual serial port at 115200 baud.

| Command | Meaning |
| --- | --- |
| `stats` | Print bitrate, counters, CAN state, and error counters |
| `sniff on` | Enable live CAN frame printing |
| `sniff off` | Disable live CAN frame printing |
| `translate on` | Enable stalk-to-cluster translation |
| `translate off` | Disable stalk-to-cluster translation |
| `send <id> <data>` | Send a standard classic CAN frame |

Example:

```text
send 5BF 07000111
```

## Build

This project expects a Zephyr workspace and Python virtual environment beside
the exported source tree:

```text
.
├── .venv/
├── can_sniff_inject/
├── scripts/
└── zephyr-workspace/
```

Build for the Nucleo-C542RC:

```sh
scripts/build-stm32.sh
```

The build output is written to:

```text
build/can_sniff_inject/zephyr/
```

## Flash

Flash with pyOCD:

```sh
.venv/bin/pyocd flash -t STM32C542RCT6 build/can_sniff_inject/zephyr/zephyr.hex
```

Or copy the generated binary to the ST-LINK mass-storage volume:

```sh
scripts/flash-stm32-mass-storage.sh
```

## Monitor

```sh
scripts/list-stm32-ports.sh
scripts/monitor-stm32.sh
```

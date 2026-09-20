# UART Communication Controller using Verilog

A UART communication controller designed in Verilog and verified using Xilinx Vivado simulation.

## Features
- 50 MHz system clock
- 9600 baud rate
- 8-bit data
- 1 start bit
- 1 stop bit
- No parity
- LSB-first transmission
- FSM-based transmitter and receiver
- Baud-rate generator
- TX-RX loopback verification

## UART Frame
Idle | Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop
  1  |   0   |          8 bits          |  1

## Modules
- baud_generator.v – Generates baud-rate timing
- uart_tx.v – UART transmitter
- uart_rx.v – UART receiver
- uart_controller.v – Top-level UART controller
- tb_uart_system.v – Simulation testbench

## Verification
TX output was connected directly to RX input for loopback testing.

Test bytes:
- 0x55
- 0xA5
- 0x3C

The transmitted and received data were verified using Vivado behavioral simulation.

## Tools
- Verilog HDL
- Xilinx Vivado

## Status
Completed and verified through behavioral simulation.

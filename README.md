# VLSI-implementation-of-UART-using-verlog-hdl
THIS REPOSITORY IS ABOUT IMPLEMENTING UART PROTOCAL USING VERILOG HDL
# UART Transmitter and Receiver (Verilog)

This project implements a fully functional **UART (Universal Asynchronous Receiver Transmitter)** in Verilog using an FSM-based approach. It consists of separate **TX**, **RX**, and **Top-Level** modules, along with a shared **Baud Generator** to manage baud rates.

---

## 📦 Module Structure

### 🔁 `tx` – Transmitter Module
Implements an FSM to serialize and transmit 8-bit data over a UART line.

#### Features:
- Supports 8-bit data format with 1 start bit, 1 stop bit.
- Accepts a **start signal** (`tx_start`) and data (`tx_data`).
- Uses a **shared baud clock** (`out_clk`) to transmit bits synchronously.
- Outputs a **TX busy flag** (`tx_busy`) for synchronization with RX.

### 📥 `rx` – Receiver Module
Deserializes incoming UART data based on a shared baud clock and the `tx_busy` signal.

#### Features:
- Waits for the **start bit** and receives 8-bit data.
- Uses **FSM-based design** with proper state transitions.
- Outputs the **received byte** (`rx_data`) and a **done flag** (`rx_done`).

### 🧠 `uart_top` – Top-Level Integration
Connects the `tx`, `rx`, and `baud_gen` modules into a single system.

#### Connections:
- Shares the **baud clock** between TX and RX.
- Routes the `tx` output directly to `rx` input.
- Exposes all top-level I/Os needed for testing and integration.

---

## ⚙️ Usage

### Inputs:
| Signal | Width | Description |
|--------|-------|-------------|
| `clk` | 1 | System clock |
| `reset` | 1 | Active-high reset |
| `sel` | 2 | Baud rate selector |
| `tx_start` | 1 | Pulse to start transmission |
| `tx_data` | 8 | Data to transmit |

### Outputs:
| Signal | Width | Description |
|--------|-------|-------------|
| `tx` | 1 | UART serial output |
| `rx_data` | 8 | Received byte |
| `rx_done` | 1 | Goes high when RX completes a byte |

---

## 📡 Baud Rate Control

The `sel` input configures the baud rate:
- `00`: 115200 bps
- `01`: 57600 bps 
- `10`: 38400 bps
- `11`: 9600 bps

> Note: Actual divisor values depend on your clock frequency and implementation in `baud_gen`.

---

## 📂 File List

- `tx.v` – UART Transmitter
- `rx.v` – UART Receiver
- `baud_gen.v` – Baud Rate Generator
- `uart_top.v` – Top-level wrapper

---

## 🧪 Test and Simulation

You can write a testbench to:
1. Apply `reset`
2. Load `tx_data`
3. Pulse `tx_start`
4. Observe `rx_data` and `rx_done`

The design supports cycle-accurate simulation with tools like:
- Icarus Verilog + GTKWave
- ModelSim / QuestaSim
- Vivado Simulator

---

## 📜 License

This project is released under the [Apache license 2.0 ]

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
⚠️ Note on Baud Clock and Transmission Delay
This UART transmitter uses a double-register method (tx_stage1 and tx_stage2) to achieve glitch-free transmission on the tx line. This technique is commonly used to avoid metastability or glitches on asynchronous outputs.

As a result:

Each bit is transmitted every two full cycles of the baud clock (out_clk), not every one.

🔧 Options to Address This Behavior:
Remove the second register (tx_stage2)

Connect tx directly to tx_stage1

✅ Reduces latency

⚠️ May introduce glitches depending on timing/synthesis tools and delays of the gates.

Double the Baud Clock Frequency

If original out_clk is 5 ns (i.e., 200 MHz), change it to 2.5 ns (400 MHz)

Keeps double-registering but restores correct transmission rate

✅ Safe and glitch-free

⚠️ Requires updated baud_gen parameters
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

---

## 👤 Author

Abhiram Naik   


---


# SPI-IN-VERILOG

## About
This repository contains a complete Verilog implementation and multiple variations of the **SPI (Serial Peripheral Interface)** protocol.  
It demonstrates SPI master–slave communication, SPI with CRC error checking, SPI in parallel and daisy-chain configurations, and hardware interfacing (e.g., PMODA4 DAC).  
It is intended for students, learners, and engineers who want to **understand and simulate SPI behavior** in different modes and use cases.

---

## Features
- SPI master and slave modules
- Multiple top-level examples:
  - Basic master-slave communication
  - Daisy-chain configuration
  - Parallel-mode configuration
  - CRC error checking version
  - Different SPI modes (CPOL/CPHA)
  - Interfacing with PMODA4 DAC
- Well-commented Verilog code for learning purposes
- Testbenches for all modules and top-level designs
- Can be simulated using ModelSim, Questa, or EDA Playground or vivado

---

## Repository Structure
```
SPI-IN-VERILOG/
│
├── PMODA4_DAC_WITH_SPI/               # Example design: interfacing a PMODA4 DAC via SPI
│   ├── spi_master.v                   # SPI master module for DAC communication
│   ├── dac_interface.v                # DAC-specific SPI command generator
│   ├── top.v                          # Integration of SPI master and DAC module
│   ├── top_tb.v                       # Testbench for PMODA4 DAC example
│   └── README.txt / waveform.pdf      # Description and simulation result
│
├── SPI_DAISY_CHAIN_CONFIGURATION/     # SPI configured in daisy-chain mode (multiple devices chained)
│   ├── spi_master_chain.v             # Master driving chained slaves
│   ├── spi_slave_chain.v              # Daisy-chain slave design
│   ├── top.v                          # Integration of master and chained slaves
│   ├── top_tb.v                       # Testbench for chain configuration
│   └── simulation_results.pdf
│
├── SPI_IN_PARALLEL_MODE/              # SPI implementation in parallel-mode (multiple data lines)
│   ├── spi_parallel_master.v          # SPI master supporting multiple parallel MOSI lines
│   ├── spi_parallel_slave.v           # Corresponding parallel slave
│   ├── top.v                          # Top-level connection
│   ├── top_tb.v                       # Testbench for parallel mode
│   └── waveforms.pdf
│
├── SPI_MASTER_SLAVE/                  # Basic SPI transfer example: one master + one slave
│   ├── spi_master.v                   # SPI master module
│   ├── spi_slave.v                    # SPI slave module
│   ├── top.v                          # Top-level module instantiating master + slave
│   ├── top_tb.v                       # Testbench for master-slave transfer
│   └── simulation_results.pdf
│
├── SPI_SUPPORTING_DIFFERENT_MODES/    # SPI supporting different modes (CPOL/CPHA = 0/1 combinations)
│   ├── spi_master_mode.v              # Master supporting CPOL/CPHA configuration
│   ├── spi_slave_mode.v               # Slave supporting CPOL/CPHA
│   ├── top.v                          # Top integration for each mode
│   ├── top_tb.v                       # Testbench verifying all SPI modes
│   └── results.pdf
│
├── SPI_WITH_CRC_ERROR_CHECKING/       # SPI with CRC/error checking mechanism
│   ├── spi_master_crc.v               # SPI master with CRC generation
│   ├── spi_slave_crc.v                # SPI slave with CRC validation
│   ├── top_crc.v                      # Top-level with master/slave CRC design
│   ├── top_crc_tb.v                   # Testbench for SPI CRC communication
│   └── crc_waveform.pdf
│
└── README.md                          # This document
```

---

## Description of Major Folders

### 🧩 PMODA4_DAC_WITH_SPI/
Implements an SPI interface to control a **PMODA4 DAC (Digital-to-Analog Converter)**. Demonstrates how to send control words to external SPI hardware.

### 🔗 SPI_DAISY_CHAIN_CONFIGURATION/
Shows how multiple SPI slaves can be **daisy-chained** together and accessed serially from a single SPI master. Demonstrates shift propagation and timing.

### ⚡ SPI_IN_PARALLEL_MODE/
Demonstrates a **parallel SPI** structure, where multiple data lines are used for faster transfer. A learning example for high-speed SPI alternatives.

### 🎛️ SPI_MASTER_SLAVE/
The **basic SPI example**: one master and one slave communicating 8-bit data. The simplest example to understand SPI fundamentals.

### ⚙️ SPI_SUPPORTING_DIFFERENT_MODES/
Implements SPI **Mode 0–3** (combinations of CPOL and CPHA). Demonstrates how clock polarity and phase affect data sampling.

### ✅ SPI_WITH_CRC_ERROR_CHECKING/
Adds **CRC (Cyclic Redundancy Check)** for error detection in SPI data transfer. Demonstrates reliability improvement in communication.

---

## Simulation Instructions (ModelSim / Questa)
Example flow:

```bash
# Create work library
vlib work
vmap work work

# Compile sources and testbench (example for basic SPI)
vlog SPI_MASTER_SLAVE/spi_master.v SPI_MASTER_SLAVE/spi_slave.v SPI_MASTER_SLAVE/top.v SPI_MASTER_SLAVE/top_tb.v

# Run simulation (console mode)
vsim -c top_tb -do "run -all; quit"
```

Run in GUI mode for waveforms:

```bash
vsim top_tb
run -all
```

---

## Key SPI Signals to Verify
| Signal | Description |
|--------|--------------|
| `SCLK` | Serial clock generated by master |
| `MOSI` | Master Out Slave In – data from master to slave |
| `MISO` | Master In Slave Out – data from slave to master (if applicable) |
| `CS`   | Chip select (active low) |
| `DONE` | Indicates end of transfer |
| `CRC_ERROR` | (in CRC design) signals transmission error |

---

## How to Extend
- Add more peripherals using SPI.
- Implement **SPI multi-byte burst transfer**.
- Add **MISO** support in master-slave designs.
- Implement **UVM testbench** for advanced verification.
- Try synthesizing on FPGA and connecting to real hardware.

---

## References
- [SPI Bus Overview – Texas Instrumnets]([https://en.wikipedia.org/wiki/Serial_Peripheral_Interface](https://www.ti.com/content/dam/videos/external-videos/en-us/6/3816841626001/6163521589001.mp4/subassets/basics-of-spi-serial-communications-presentation.pdf))
- FPGA4Student & ASIC World SPI tutorials

---

## Notes
- These designs are meant for **learning and simulation**, not for direct ASIC/FPGA production.
- All testbenches produce simulation waveforms you can observe in ModelSim/Questa or EDA Playground.

---

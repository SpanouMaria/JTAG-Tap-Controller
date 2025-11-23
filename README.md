# JTAG TAP Controller & Boundary Scan

This repository contains the full implementation of the **JTAG Boundary Scan Architecture**, based on Exercises **3** and **4** from the course *Testability and Dependability of Electronic Systems* (University of Ioannina).

The project includes all fundamental JTAG components, the TAP controller FSM, Boundary Scan Cells, Instruction Register logic, multiplexers, and integration of the complete boundary scan chain around a CUT (Circuit Under Test). 

---

## Overview

The design follows the IEEE 1149.1 boundary-scan standard and implements:

- JTAG **TAP Controller** (16-state FSM)
- **Boundary Scan Cells (BSC)** for all input/output pins
- **Bypass Register (BR)**
- **Instruction Register (IR)** + IR cells
- **Instruction Decoder**
- **Multiplexers** for DR/IR selection and TDO path
- Support for **SAMPLE**, **PRELOAD**, **SHIFT**, **UPDATE**, **CAPTURE** operations

All modules are written in **VHDL**, verified with dedicated **testbenches**, and validated using simulation waveforms.

---

## JTAG Structural Components

### Implemented Modules (VHDL)

- `BSC.vhd` — Boundary Scan Cell  
- `BR.vhd` — Bypass Register  
- `IR_Cell.vhd` — Instruction Register Cell  
- `IR_Register.vhd` — Full IR  
- `Decoder.vhd` — Instruction decode logic  

According to the assignment:  
- BSC must support CAP/UPD flip-flops, internal logic path, shift path  
- IR cell provided in assignment specification  
- BR is a single-bit shift register used when BYPASS instruction is active  
- All components must match the Quartus schematic 

### Testbench Requirements

- Full verification of all BSC functions:
  - CAP from internal logic  
  - CAP from shift input  
  - SHIFT operation  
  - UPDATE to UPD flip-flop  
  - Normal mode data propagation  
  - Test mode override  
- Waveforms included and described in the report  

---

## TAP Controller FSM

Implemented file:

- `TAP_Controller.vhd`

The FSM follows the official JTAG 16-state diagram (Test-Logic-Reset → Run-Test/Idle → DR/IR scan paths).  
Transitions depend on the **TMS** value at each rising edge of **TCK**.  
Behavior matches the specifications shown in the assignment PDF (state-by-state mapping). :contentReference[oaicite:5]{index=5}

### Testbench

- Drives TMS sequences and verifies all legal state transitions  
- Includes waveform analysis  
- Example test: TMS sequence `01001` must end in state **Exit1-DR** (as required)  

---

## Complete JTAG Architecture Integration

This part connects all components to form a full JTAG boundary scan system around a CUT.  
Main modules:

- **CUT logic** (given circuit, no flip-flops allowed)  
- **Boundary Scan Register** (all BSCs chained)  
- **IR Register + Decoder**  
- **Bypass Register**  
- **MUX-1 & MUX-2** for selecting TDI/TDO data paths  
- **TAP Controller signals** connected to:
  - Shift_DR  
  - Capture_DR  
  - Update_DR  
  - Shift_IR  
  - Capture_IR  
  - Update_IR  
  - Run_Test  
  - Reset  

---

## Testbench for Full System

A complete JTAG testbench was created to verify:

- SAMPLE  
- PRELOAD  
- BYPASS operation  
- Instruction decoding  
- Correct shift path through BSR and BR  
- Correct TDO output  
- TAP Controller synchronization with TCK  

Waveforms from all operations were captured and analyzed.

---

## Technologies & Tools

- **HDL:** VHDL  
- **Development Tools:** Quartus Prime  
- **Simulation:** ModelSim / QuestaSim  
- **Schematic Verification:** Quartus RTL Viewer & Technology Map Viewer  
- **Target:** Generic FPGA architecture  

---


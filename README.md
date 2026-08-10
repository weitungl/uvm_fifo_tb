# UVM Verification IP for FIFO
This repository contains a modular and scalable UVM (Universal Verification Methodology) Testbench for verifying a Synchronous FIFO IP. 
The testbench features constrained-random stimulus generation, full TLM architecture, functional coverage collection, scoreboarding, 
and dynamic factory overrides for error/pattern injection.

## Testbench Architecture
<img width="829" height="575" alt="截圖 2026-08-10 晚上9 44 04" src="https://github.com/user-attachments/assets/ef1ddb66-74d6-4783-b039-82730176d9f8" />


## Key Highlights
* Active Agents: Separate write_agent and read_agent, each instantiating its own Sequencer, Driver, and Monitor.
* Constrained-Random Verification (CRV): Randomized write/read transactions with varying delays (zero_delay, short_delay, long_delay).
* Scoreboard Integration: Automatic data checking using UVM TLM exports.
* Functional Coverage Component: Direct coverage sampling from Driver transactions (cp_op, cp_delay, and cross_op_delay).
* Factory Type Override: Demonstrates dynamic object replacement (fifo_corrupt_transaction) to inject specific data patterns without modifying testbench source code.

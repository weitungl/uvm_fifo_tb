# UVM Verification IP for FIFO
This repository contains a modular and scalable UVM (Universal Verification Methodology) Testbench for verifying a Synchronous FIFO IP. 
The testbench features constrained-random stimulus generation, full TLM architecture, functional coverage collection, scoreboarding, 
and dynamic factory overrides for error/pattern injection.

## Testbench Architecture
<img width="1364" height="1134" alt="image" src="https://github.com/user-attachments/assets/1449fe7e-50a3-4651-9b44-0721e14e50cd" />

## Key Highlights
* **Dual Active Agents**: Independent write and read agents, each containing a Sequencer, Driver, and Monitor.
* **Constrained-Random Verification (CRV)**: Randomized read/write transactions with configurable delays.
* **Self-Checking Scoreboard**: Queue-based reference model that verifies data integrity and FIFO ordering through UVM TLM analysis ports and FIFOs.
* **Functional Coverage**: Transaction-level stimulus coverage and interface-level FIFO behavior coverage.
* **SystemVerilog Assertions (SVA)**: Checks reset behavior, full/empty consistency, and overflow/underflow protection. Additional assertions use bind to monitor internal read/write pointers without modifying the RTL.
* **Factory Type Override**: Demonstrates transaction replacement using fifo_corrupt_transaction.

## Components
* **fifo_sequencer**: Controls transaction flow and moves sequence items to drivers.
* **fifo_write/read_driver**: Converts TLM transactions into physical signals to drive the DUT interface, while sending driving metrics to Coverage.
* **fifo_write/read_monitor**: Passively captures bus activity, packages signals into transactions, and broadcasts them to the Scoreboard via TLM analysis ports.
* **fifo_write/read_agent**: Encapsulates Sequencer, Driver, and Monitor into a reusable container.
* **fifo_scoreboard**: Compares actual read data against a queue-based reference model.
* **fifo_coverage**: Collects stimulus and FIFO behavior coverage.
* **fifo_assertion**: Checks internal pointer stability through SVA and bind.

## Test Cases
* **fifo_rand_test**: Runs randomized transactions across write and read agents to stress FIFO operation and fill coverage bins with random timing delays (zero_delay, short_delay, long_delay).
* **fifo_full_empty_test**: Directed test driving boundary condition sequences to verify FIFO overflow and underflow protections.
* **fifo_override_test**: Uses UVM Factory Type Override to inject custom data patterns and fixed delays without altering existing testbench settings.
* **fifo_reset_test**: Reset recovery after writing data into the FIFO.
* **fifo_full_simultaneous_test**: Simultaneous read/write requests while FIFO is full.

## Verification Results
### 1. Data Integrity 
The scoreboard uses an in-order reference queue to predict expected read data and compare it against actual DUT output.
* **Zero Data Mismatches**: All observed read transactions matched the expected data from the reference queue.
* **FIFO Ordering**: Verified in-order data delivery under randomized and directed read/write scenarios.
* **Reset Recovery**: Verified correct data transactions after mid-test reset.
* **Regression**: All five test cases completed with zero reported data mismatches.
  
### 2. Coverage
* **Code Coverage**: 100%
* **Functional Coverage**: 100%

Functional coverage includes transaction types, delay combinations, FIFO status, and simultaneous read/write scenarios.

### 3. Assertion Verification
* Verified FIFO reset behavior and full/empty consistency.
* Checked overflow and underflow protection using SVA and bound internal pointer assertions.
* No assertion failures observed during regression.

## How to Run

### Requirements
- Synopsys VCS with UVM support
- Synopsys URG for coverage reporting

### Run All Tests
Compile the testbench and run all five tests.

```bash
make all
```

### Run an Individual Test
Compile and run a specific test.

```bash
make compile
make sim TEST=fifo_rand_test
```

### Generate Coverage Report
```bash
make cov
```

### Clean Generated Files
```bash
make clean
```

The Makefile automates compilation and test execution. The regression runs all five tests sequentially, with coverage collected separately for each test and merged for reporting.

**Tools**
* SystemVerilog / UVM
* Synopsys VCS
* Synopsys Verdi
* Synopsys URG
* GNU Make

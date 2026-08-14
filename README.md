# UVM Verification IP for FIFO
This repository contains a modular and scalable UVM (Universal Verification Methodology) Testbench for verifying a Synchronous FIFO IP. 
The testbench features constrained-random stimulus generation, full TLM architecture, functional coverage collection, scoreboarding, 
and dynamic factory overrides for error/pattern injection.

## Testbench Architecture
<img width="829" height="575" alt="截圖 2026-08-10 晚上9 44 04" src="https://github.com/user-attachments/assets/ef1ddb66-74d6-4783-b039-82730176d9f8" />

## Key Highlights
* **Active Agents**: Separate write_agent and read_agent, each instantiating its own Sequencer, Driver, and Monitor.
* **Constrained-Random Verification (CRV)**: Randomized write/read transactions with varying delays (zero_delay, short_delay, long_delay).
* **Scoreboard Integration**: Automatic data checking using UVM TLM exports.
* **Functional Coverage Component**: Direct coverage sampling from Driver transactions (cp_op, cp_delay, and cross_op_delay).
* **Factory Type Override**: Demonstrates dynamic object replacement (fifo_corrupt_transaction) to inject specific data patterns without modifying testbench source code.

## Components
* **fifo_sequencer**: Controls transaction flow and moves sequence items to drivers.
* **fifo_write/read_driver**: Converts TLM transactions into physical signals to drive the DUT interface, while sending driving metrics to Coverage.
* **fifo_write/read_monitor**: Passively captures bus activity, packages signals into transactions, and broadcasts them to the Scoreboard via TLM analysis ports.
* **fifo_write/read_agent**: Encapsulates Sequencer, Driver, and Monitor into a reusable container.
* **fifo_scoreboard**: Stores expected write transactions in a TLM FIFO and compares them against actual read output transactions to verify data integrity.
* **fifo_coverage**: Collects functional coverage metrics for operation types and inter-transaction delays.

## Test Cases
* **fifo_rand_test**: Runs randomized transactions across write and read agents to stress FIFO operation and fill coverage bins with random timing delays (zero_delay, short_delay, long_delay).
* **fifo_full_empty_test**: Directed test driving boundary condition sequences to verify FIFO overflow and underflow protections.
* **fifo_override_test**: Uses UVM Factory Type Override to inject custom data patterns and fixed delays without altering existing testbench settings.

## Verification Results
### 1. Data Integrity & Scoreboard Checking
The dynamic self-checking scoreboard verified the correctness of data flow across all test cases:
* **Zero Data Mismatch**: 100% data integrity verified for all popped transactions against the expected golden queue.
* **In-Order Delivery**: Confirmed strict FIFO order with zero protocol or data corruption under random read/write delays.
* **Drain & Boundary Verification**: Confirmed complete FIFO drain (zero residual data) and verified correct `full`/`empty` flag behavior during the directed `fifo_full_empty_test`.
* **Zero UVM Errors**: Successfully passed all randomized and directed tests with 0 `UVM_ERROR` and 0 `UVM_FATAL` reports.
### 2. Functional Coverage
The testbench achieved **100.00% Functional Coverage**:
* `cp_op` (**100.00%**): Fully covered both `write_op` and `read_op` transactions.
* `cp_delay` (**100.00%**): Verified all timing delay bins (zero_delay, short_delay, and long_delay).
* `cross_op_delay` (**100.00%**): Achieved 100% coverage across all cross-bins between operation types and delay conditions.

## How to Run
**Requirements**
* Synopsys VCS
* UVM Library

## Execution Commands

```Bash
# 1. Run randomized test
make

# 2. Run full/empty boundary test
make TEST=fifo_full_empty_test

# 3. Run test with UVM Factory Override
make TEST=fifo_override_test

# 4. Generate coverage report
make cov

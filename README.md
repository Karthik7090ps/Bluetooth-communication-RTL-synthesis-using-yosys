# Bluetooth communication RTL synthesis using YOSYS
I will be giving pictures for all the steps in my system

1. **Install Icarus Verilog:**
   If not already installed, use your system's package manager to install Icarus Verilog:
   ```bash
   # For Ubuntu/Debian
   sudo apt-get install iverilog
   
   # For macOS with Homebrew
   brew install iverilog
   ```

2. **Navigate to Your Files:**
   Go to the directory where your Verilog files are located:
   ```bash
   cd /path/to/your/files
   ```
![Screenshot from 2023-08-26 01-17-57](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/8c7ddedd-f206-4401-9ee9-eb99467e7a36)

3. **Compile and Simulate:**
   Compile your Verilog module and testbench:
   ```bash
   iverilog  <module.v> <module_tb.v>
   ```
   the compiles output will be stored in the path directory
   
5. **Run the Simulation:**
   Run the command for simulation:
   ```bash
   ./a.out  #a.out is the output file after compiling
   ```

6. **View Pre-Synthesis Graph (GTKWave):**
   Install GTKWave using your package manager if needed:
   ```bash
   # For Ubuntu/Debian
   sudo apt-get install gtkwave
   
   # For macOS with Homebrew
   brew install gtkwave
   ```

   Open the simulation output VCD file in GTKWave to view the waveform:
   ```bash
   gtkwave <module.vcd>
   ```
   **note:** vcd file will not be generated if dumpvars is not declared in the testbench.
   example:
   

Replace `<module.v>` and `<module_tb.v>` with your actual Verilog module and testbench file names. These steps guide you through compiling, simulating, and visualizing the pre-synthesis waveform using terminal commands.
## PreSynthesis Waveforms of the Uart Reciever communication module 


![Screenshot from 2023-08-26 01-35-44](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/df8dea2e-bcf7-46b2-8d71-5040935e5d27)

## TIP: Note the path of the library file in prior for further uses
  ```bash
   readlink -f <libraryname>  // in the current path
   ```
## Synthesize Using Yosys 

After obtaining the full path of your Verilog files and simulating them, the next step is synthesis using Yosys. Here's what you need to do:

1. **Install Yosys:**
   If you haven't already, install Yosys on your system using your package manager or the method suitable for your platform.

2. **Navigate to Your Files:**
   Make sure you are in the directory containing your Verilog files.

3. **Synthesize Using Yosys:**
   Read your verilog module script for synthesis with below command  
   ```bash
   read_verilog <module.v>
   ```
   Replace `module.v` with the name of your verilog synthesis script.

4. **Read Liberty File:**
   Once the synthesis is complete, you need to read the liberty file for library cells' information. Use either the relative path or the full path to the liberty file. For example:
   ```bash
   # Using relative path
   read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
   
   # Using full path
   read_liberty /home/user/synthosphere/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

This step sets the stage for the actual synthesis process. Yosys will utilize the specified liberty file for cell library information during synthesis.

Remember to replace `your_synthesis_script.ys` and the paths accordingly with your specific filenames and paths.

Proceed with these steps to initiate synthesis and library reading in preparation for the final stages of the hardware design process.
![Screenshot from 2023-08-26 01-38-56](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/bfe1f19c-fe6c-49ec-a1af-4550a414c160)


5. ## Specify Module for Synthesis

After reading the Liberty file and setting up Yosys, you can specify the module for synthesis:

- Use the `-top` option to specify the module you want to synthesize:
   ```tcl
   synth -top your_module_name
   ```
   you can also give more than one file for synthesis
  
Certainly, here's a concise explanation of the synthesis and optimization results:
![Screenshot from 2023-08-26 01-49-32](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/e478796f-853e-423a-8104-97a10088edbc)

6. ## Synthesis and Optimization Results

After executing the synthesis and optimization steps using Yosys, you'll receive valuable insights into the optimization process and your design's characteristics.

![Screenshot from 2023-08-26 02-01-44](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/6fab8dfd-6f7d-49f2-8933-6431f09a312c)

### Optimization Passes
Optimization involves several passes aimed at improving your design's efficiency and performance. These passes may include:
- **OPT_EXPR**: This pass performs constant folding, simplifying expressions with constants.
- **OPT_MERGE**: Identical cells are detected and merged, reducing redundancy.
- **OPT_RMDFF**: D-type flip-flops (DFFs) with constant inputs are removed.
- **OPT_CLEAN**: Unused cells and wires are removed to declutter the design.

### Hierarchy Management
The hierarchy pass analyzes your design's structure. It ensures that unused modules are removed and provides an overview of your design's hierarchy.

### Design Statistics
Statistics give you a snapshot of your design's key characteristics, such as:
- The number of wires and wire bits used in the design.
- The number of public wires available externally.
- The number of memory elements (if any) and memory bits.
- The number of cells in your design, categorized by type (e.g., ANDNOT, MUX, DFF).

### Problem Checking
The final step involves checking for any obvious problems in your design. If no issues are found, it indicates that your design is in good shape for the next stages.

These results collectively reflect the impact of optimization, hierarchy management, and integrity checking on your design. They offer crucial insights into the efficiency, structure, and correctness of your synthesized design, aiding in refining your hardware module.

![Screenshot from 2023-08-26 02-01-55](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/d6415a75-e92c-4cd3-aa46-3923c7b08187)

## Applying DFF Library Mapping

After the synthesis and optimization steps, the next phase involves applying the Delay Flip-Flop (DFF) library mapping using the `dfflibmap` command:

1. **Navigate to the Design Directory:**
   Make sure you are in the directory where your design files are located.

2. **Use `dfflibmap` with Path:**
   Open your terminal and use the following command to apply the DFF library mapping using the `dfflibmap` command. You need to specify the path to the library file you want to use:
   ```bash
   dfflibmap -liberty /path/to/your/library.lib -lib cell_mapping_file.map your_design_name your_design_name_mapped
   ```
  ![Screenshot from 2023-08-26 02-06-08](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/30642966-31aa-4379-b85f-2f7e011f218b)


   Replace `/path/to/your/library.lib` with the actual path to your library file, `cell_mapping_file.map` with the mapping file for cell substitutions, `your_design_name` with the name of your design, and `your_design_name_mapped` with the name you want for the mapped design.

This step involves mapping D-type flip-flops to cells from the specified library, which helps optimize timing and performance characteristics of your design.

Remember to replace placeholders with your actual file and design names.

This command contributes to enhancing the performance and functionality of your design by leveraging the characteristics of the chosen DFF cells from the library.

Certainly, here's a description of the command you provided for GitHub:

## Applying ABC Logic Synthesis with Liberty File

After performing previous steps and mapping D-type flip-flops (DFFs) using the `dfflibmap` command, the next stage involves using ABC for logic synthesis with a specified Liberty library file:

 **Execute ABC Logic Synthesis:**
   Use the following command to initiate ABC logic synthesis, referencing the Liberty library file for technology-specific information:
   ```bash
   abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```
![Screenshot from 2023-08-26 02-07-13](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/17a87237-e642-46d2-bc8f-943be59d923b)

By executing this command, you employ the ABC tool to perform logic synthesis while considering the characteristics outlined in the provided Liberty library file. ABC utilizes this information to optimize your design's logic gates and create a more efficient netlist.

![Screenshot from 2023-08-26 02-07-23](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/d56dd727-05cf-469d-a6e4-4c603f39525f)

Remember to replace `../lib/sky130_fd_sc_hd__tt_025C_1v80.lib` with the correct path to your Liberty library file. This command is crucial for refining your design's logic and enhancing its performance.

## Viewing RTL Sketch Using ABC

After completing the ABC logic synthesis process, you can visualize the synthesized RTL (Register-Transfer Level) sketch of your design using the `show` command:

 **Execute `show` Command:**
   Use the following command to view the synthesized RTL sketch of your design:
   ```bash
   show your_module_name
   ```
![Screenshot from 2023-08-26 02-12-05](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/f2b1eb27-eaff-429c-b90e-6b852339991c)

## RTL OUTPUT

![Screenshot from 2023-08-26 02-11-31](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/42e312d1-ca94-4b85-a8a6-0ef0a0617e8d)

## Zoomed View

![Screenshot from 2023-08-26 02-11-47](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/21fb624e-6036-4f86-bb31-e859e47821de)

   Replace `your_module_name` with the actual name of the module you want to view.

By executing this command, you'll generate an RTL visualization that represents the logic implemented after ABC synthesis. This is a crucial step to verify that the logic synthesis process accurately captures the functionality of your design.

Remember to interpret the generated RTL sketch and validate that it aligns with your design's intent. This visualization provides insight into how your design's logic has been transformed and optimized during the synthesis process.

Please adjust the command according to your module name and specific requirements.

This visualization contributes to your understanding of the synthesis outcome and helps ensure that the synthesis process was successful in capturing your design's functionality.

Certainly, here's the continuation of your information for GitHub:

## Generating Verilog Output from Yosys

After visualizing the RTL sketch using the `show` command, the next steps involve generating Verilog output from Yosys for further analysis and validation:

**Execute `write_verilog` Command:**
   In the Yosys console, use the following commands to generate Verilog output files:
   ```tcl
   yosys> write_verilog test.v
![Screenshot from 2023-08-26 02-14-58](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/1a4fc838-8e31-4dba-b346-c0cd1e60744f)

   yosys> write_verilog -noattr netlist_test.v
   ```
![Screenshot from 2023-08-26 02-15-31](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/1d05e1c0-3bd5-4a95-a4ae-a89d962f7441)

   The first command generates a Verilog file named `test.v`, including attributes.
   The second command generates a Verilog file named `netlist_test.v` without attributes.

By executing these commands, you'll create Verilog output files that represent the synthesized design. These files can be used for further simulation, analysis, and integration into larger systems.

- exit the yosys and runt the below command to make generate vcd file for the generated netlist
   ```bash
   iverilog netlist_test.v ../verilog_model/primitives.v ../verilog_model/sky130_fd_sc_hd_edited.v
   ```
- now open the gtk wave with generated vcd file to get the synthesized output waveforms
  
## Waveforms after synthesise

![postsyn](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/0cdbfd28-9904-4d71-96de-f1690be35a3f)

## Logics Behing the code and more
this code is used to establish successfull communication between smartphone and the main DIGITAL Logic device.
This code can be used for 
- making home automation
- Automating things or Devices that uses Bluetooth communication
- establishing communication between any device using UART protocol
The communication can be explained in these 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600, 1000000, 1500000 baudrates
## Design Requirements (for establishing communication)
The considerations before establishing good and reliable communications are discussed below

### UART Receiver Hardware Design

This document outlines the design considerations for creating a UART receiver module compliant with the following specifications:

- Baudrate: 9600 bits/second
- Internal clock: 100 MHz
- Configuration: 1 Start bit, 8 Data bits, 1 Stop bit, 0 Parity
- Receiver FIFO: 8-bit depth

### Baudrate

Baudrate refers to the transmission rate of data in bits per second. For this UART receiver, we are targeting a baud rate of 9600 bits per second, ensuring synchronization between the transmitter and receiver.

### Clock Signal

To efficiently receive data through the RX pin, an internal clock is necessary. In this design, we leverage the on-chip clock source available on boards, typically ranging from 50 MHz to 100 MHz. We will use the 100 MHz clock to sample the RX pin and detect level changes.

### Number of Bits in a Transmission

The UART standard specifies the structure of each data transmission. Since our configuration is 1 Start bit, 8 Data bits, and 1 Stop bit (with no parity bit), each transmission consists of 10 bits. The bit sequence is as follows:
```
START BIT - 8 DATA BITS - STOP BIT
```

### FIFO Data Storage

To manage the stream of incoming data, a First-In-First-Out (FIFO) buffer is crucial. Since UART transmits data in a series of bits, we need to capture and store the 8 data bits once the complete 10-bit transmission is received. This FIFO buffer, also known as a register, ensures smooth data handling and processing.

### State Machine

The UART receiver's functionality follows a cyclical and repetitive pattern, progressing through fixed states. To effectively manage this operation, a state machine is employed. This state machine guides the processing flow, allowing the receiver to handle incoming data accurately.

### Implementation Details

For this UART receiver module, the following characteristics are in focus:

- Baudrate: 9600 bits/second
- Internal clock: 100 MHz
- Data format: 1 Start bit, 8 Data bits, 1 Stop bit
- Receiver FIFO depth: 8 bits

The design integrates the clock signal to sample incoming data, employs a state machine to manage the cyclic operation, and utilizes an 8-bit FIFO buffer to capture the transmitted data. The design ensures compatibility with the specified UART configuration.

Please refer to the accompanying code and documentation for a detailed implementation of the UART receiver based on the above specifications.
### code for baudrate
```
// Counter for Baudrate
always @ (posedge clock) begin  
    if (resetn == 1'b0) begin 
        counter <= 14'd0;
    end 
    else begin 
        if (state != `IDLE) begin 
            if (counter_end == 1'b1) counter <= 14'd0;
            else counter <= counter + 14'd1;
        end 
    end 
end

// RX Data Counter 
always @ (posedge clock) begin 
    if (resetn == 1'b0) data_cnt <= 3'b000;
    else if ((state == `DATA) && (counter_end == 1'b1)) data_cnt <= data_cnt + 3'd1;
end
```
## State Machine Diagram:
State Machine Diagram:
Using state machine with 4 State. IDLE, START, DATA, STOP. Therefore, a 2-bit register is needed to encode the above 4
states. Where, START and STOP last for 1 bit time according to Baudrate. DATA lasts for 8 bit times according to Baudrate.
IDLE has no time constant, which is the state that exists when no process has received a request from the RX signal.
```

  [ IDLE ] --- (No request) --> [ IDLE ]
     ^                               |
     |                               v
     |        (Request: Start bit)   |
     +-------- [ START ] <------------
                                      |
                                      v
  (Request: Data bit 1)            (Request: Stop bit)
     |                               |
     v                               v
  [ DATA ] ---> [ DATA ] ---> [ DATA ] ---> [ DATA ]
     ^           ^           ^           ^       |
     |           |           |           |       v
     +-----------+-----------+-----------+---- [ STOP ]
```

Legend:
- [ State ]: Represents a state in the state machine.
- (Request: Event): Indicates an event that triggers a transition.
- --->: Represents a transition from one state to another.

## Timing Counter
The timing counter is utilized to measure the number of internal clock pulses required to generate the bit time as per the specified baud rate. For instance, in the case of a 9600 Baudrate, one second corresponds to 9600 bits, translating to a frequency of 9600 Hz. Thus, the duration of a single bit becomes 1/9600 = 0.104167 ms (1041670 ns). Given an internal clock frequency of 100 MHz (10 ns period), the timing counter needs to reach a value of 104167 to achieve the desired bit period.

The decimal value 104167 translates to 13 binary bits: `13'b1100101101110`. Consequently, the timing counter requires a bit width of 13 to accommodate this value.

## Data Bit Counter
The Data Bit counter serves two main purposes:

1. It contributes to establishing the stop condition for the state machine in the DATA state.
2. It acts as an index for storing the received value in the FIFO.

As the number of data bits is 8, ranging from index 0 to 7, the maximum value for the Data Bit Counter is 7. This constraint implies that 3 bits are sufficient to represent the Data Bit Counter's values.

## Received Data FIFO
The Received Data FIFO (First-In-First-Out) is a buffer used to store the received data temporarily. Given that the UART configuration consists of 8 data bits, the FIFO should be able to store these 8-bit data packets as they arrive.

![rx_clock](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/ff5256da-128c-4f6c-bcc4-b0ab824385e2)

## Synchronizing the RX Signal

In order to facilitate the transition from the IDLE state to the START state, a signal is necessary to indicate the falling edge of the RX signal. To achieve this, a synchronization step must be employed to align the RX signal with the internal clock. This synchronization process is essential to prevent signal instability arising from potential phase differences between the RX signal and the internal clock.

A common technique to achieve this synchronization involves employing a synchronous circuit composed of two Flip-Flops connected in series. These Flip-Flops are clocked using the internal clock, ensuring that the RX signal is effectively synchronized and aligned for further processing within the receiver module.

By synchronizing the RX signal, we ensure that transitions between different states of the UART receiver occur reliably, unaffected by potential timing variations between the incoming RX signal and the internal clock.

![4](https://github.com/Karthik7090ps/Bluetooth-home-automation-with-on-board-communication/assets/110128289/f2717faa-f7a6-4142-954d-f8746b2189c9)




# CompArch Lab 3: CPU

**Work Plan due:** Monday, November 6

**Assembly test due:** Tuesday, November 14 before class

**Lab due:** Friday, November 17

The goal of this lab is to design, create, and test a 32-bit CPU.

You will work in groups of 2-4. You may shuffle teams if you so choose. You should consider the complexity of processor design (e.g. single-cycle, pipelined) you plan to attempt while forming teams. 


## Work Plan ##

Draft a work plan for this lab, which should include the type of processor you plan to design. Regardless of the final design you choose, we recommend that you start by building a working single-cycle CPU. Break down the lab in to small portions, and for each portion predict how long it will take (in hours) and when it will be done by (date). 

We strongly suggest you include a mid-point check in with course staff in your plan. One good thing to do at this check-in or earlier would be to review your block diagram.

Use your work plan reflections from the previous labs to help with this task. You will reflect on your actual path vs. the work plan at the end of the lab.

**Submit this plan by November 6** by pushing `work_plan.txt` to GitHub. (Markdown/PDF format also OK) Include team member names in your work plan, especially if you have reshuffled.


## Processor ##

Create a 32-bit MIPS-subset CPU that supports (at least) the following instructions:

	LW, SW, J, JR, JAL, BNE, XORI, ADDI, ADD, SUB, SLT
    
You may choose any processor design style you like (single-cycle, multi-cycle, pipelined) as long as it implements this subset of the ISA. 

Every module of Verilog you write must be **commented and tested**.  Running assembly programs only tests the system at a high level – each module needs to be unit tested on its own with a Verilog test bench. Include a master script that runs your entire test suite.



## Programs ##

You will write, assemble and run a set of programs on your CPU that act as a high-level test-bench.  These programs need to exercise all of the portions of your design and give a clear pass/fail response.

We will work on one test program (Fibonacci) in class. In addition, you must write (at least) one test assembly program of your own. We will collect these test programs and redistribute them to all teams, so that you have a richer variety of assembly tests for your processor.

### Submitting your test program ###

**Due: November 14 before class** by GitHub pull request

In addition to your actual test assembly code, write a short README with:
 - Expected results of the test
 - Any memory layout requirements (e.g. `.data` section)
 - Any instructions used outside the basic required subset (ok to use, but try to submit at least one test program everyone can run)

Submit the test program and README by submitting a pull request to the main course repository. Code should be in `/asmtest/<your-team-name>/` (you may use subfolders if you submit multiple tests).

After submitting your test program, you may use any of the programs written by your peers to test your processor.



## Deliverables ##

**Due: Friday, November 17** by pushing to GitHub and submitting a pull request
 - Verilog and test benches for your processor design
 - Assembly test(s) with README 
 - Any necessary scripts
 - Report (PDF or MarkDown), including:
   - Written description and block diagram of your processor architecture. Consider including selected RTL to capture how instructions are implemented.
   - Description of your test plan and results
   - Some performance/area analysis of your design. This can be for the full processor, or a case study of choices made designing a single unit. It can be based on calculation, simulation, Vivado synthesis results, or a mix of all three.
   - Work plan reflection


Each team will also demo their work in class after break.
 

## Notes/Hints ##

### Design Reuse ###
You may freely reuse code created for previous labs, even code written by another team or the instructors. Reusing code does not change your obligation to understand it and provide appropriate test benches.

**Each example of reuse should be documented.** 

### Synthesis ###
You are **not** required to implement your design on FPGA. You may want to synthesize your design (or parts of it) with Vivado to collect performance/area data.

### Assembling ###
[MARS](http://courses.missouristate.edu/kenvollmar/mars/) is a very nice assembler. It allows you to see the machine code (actual bits) of the instructions, which is useful for debugging. 


### Psuedo-Instructions ###
There are many instructions supported by MARS that aren’t "real" MIPS instructions, but instead map onto other instructions. Your processor should only implement instructions from the actual MIPS ISA (see the [Instruction Reference sheet](https://sites.google.com/site/ca16fall/resources/mips) for a complete listing).

### Initializing Memory ###
You can initialize a memory (e.g. data memory or instruction memory) from a file with `$readmemb` or `$readmemh`.  This will make your life very much easier!

For example, you could load a program into your data memory by putting your machine code in hexadecimal format in a file named `file.dat` and using something like this for your instruction memory.  

```verilog
module memory
(
  input clk, regWE,
  input[9:0] Addr,
  input[31:0] DataIn,
  output[31:0]  DataOut
);
  
  reg [31:0] mem[1023:0];  
  
  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
    end
  end
  
  initial $readmemh(“file.dat”, mem);
    
  assign DataOut = mem[Addr];
endmodule
```

You may need to fiddle with the `Addr` bus to make it fit your design, depending on how you handle the "address is always a multiple of 4" (word alignment) issue.

This memory initialization only works in simulation; it will be ignored by Vivado (which is ok).

### Memory Configuration ###

In MARS, go to "Settings -> Memory Configuration".  Changing this to "Compact, Text at Address 0" will give you a decent memory layout to start with.  This will put your program (text) at address `0`, your data at address `0x1000`, and your stack pointer will start at `0x3ffc`.

You will need to manually set your stack pointer in your Verilog simulation.  This is done automatically for you in MARS.


//`include "instruction_memory.v"

module instruction_memory_test ();

  // Instantiate device/module under test
  reg clk,regWE;
  reg [31:0] DataIn,Addr;  // Primary test inputs
  wire [31:0] DataOut;    // Test outputs

  initial clk=0;
  always #10 clk=!clk;
  
  instruction_memory im(.clk (clk),.regWE (regWE),.DataIn (DataIn),.Addr (Addr),.DataOut (DataOut));  // Module to be tested
  
  task checkTestCase;
  input [31:0] expectedOut;
  begin
	if (DataOut != expectedOut) begin
		$display("Test Case Failed: expected %b, received %b",expectedOut,DataOut);
	end
  end
  endtask
		

  // Run sequence of test stimuli
  initial begin
    regWE = 1'b1; DataIn = 20; Addr = 20; #20;                                // Set A and B, wait for update (#1)
    checkTestCase(20); #20;
    regWE = 0; DataIn = 40; Addr = 20; #20;  
    checkTestCase(20); #20;
  end
endmodule    // End demorgan_test
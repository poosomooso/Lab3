`include "signextend.v"

module signextendtest ();

  // Instantiate device/module under test
  reg [15:0] A;                // Primary test inputs
  wire [31:0] result;

  signextend dut(A, result);  // Module to be tested


  // Run sequence of test stimuli
  initial begin
    A=16'b1010110011100010; #1
    if(result==32'b11111111111111111010110011100010)
      $display("Test case 1 passed");
    else
      $display("Test case 1 failed");

    A=16'b0010110011100010; #1
    if(result==32'b00000000000000000010110011100010)
      $display("Test case 1 passed");
    else
      $display("Test case 1 failed");
  end
endmodule    // End demorgan_test
//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------
`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[1023:0] AllOutputs;
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .AllOutputs(AllOutputs),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  integer i, j;
  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

    // Test Case 1
    //   Writing to registers
    for (i = 0; i <= 'b11111; i = i + 1) begin
      WriteRegister = i;
      WriteData = i;
      RegWrite = 1;
      ReadRegister1 = i;
      ReadRegister2 = i;
      #5 Clk=1; #5 Clk=0;

      if((ReadData1 != i) || (ReadData2 != i)) begin
        dutpassed = 0;
        $display("Test Case 1 Failed : failed to write to register %d", i);
      end
    end

    // Test Case 2
    //   write to 0 register
    //   should always return 0
    WriteRegister = 5'd0;
    WriteData = 32'hffffffff;
    RegWrite = 1;
    ReadRegister1 = 5'd0;
    ReadRegister2 = 5'd0;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 0) || (ReadData2 != 0)) begin
      dutpassed = 0;
      $display("Test Case 2 Failed : wrote to zero port");
    end

    // Test Case 3
    //   write enabled
    //   should return unchanged value from above
    for (i = 0; i <= 'b11111; i = i + 1) begin
      WriteRegister = i;
      WriteData = 32'hffffffff;
      RegWrite = 0;
      ReadRegister1 = i;
      ReadRegister2 = i;
      #5 Clk=1; #5 Clk=0;

      if((ReadData1 != i) || (ReadData2 != i)) begin
        dutpassed = 0;
        $display("Test Case 3 Failed : register %d changed when wrenable is false", i);
      end
    end

    // Test Case 4
    //   Broken decoder
    //   All registers should start with their address in their memory
    for (i = 0; i <= 'b11111; i = i + 1) begin
      WriteRegister = i;
      WriteData = 32'hffffffff;
      RegWrite = 1;
      #5 Clk=1; #5 Clk=0;

      for (j = 0; j <= 'b11111; j = j + 2) begin
        if (j != i) begin
          RegWrite = 0;
          ReadRegister1 = i;
          ReadRegister2 = i + 1;
          #5 Clk=1; #5 Clk=0;

          if((ReadData1 == i) || (ReadData2 == i)) begin
            dutpassed = 0;
            $display("Test Case 4 Failed : value for register %d written to multiple registers", i);
          end
        end
      end
    end

    // All done!  Wait a moment and signal test completion.
    #5
    endtest = 1;

end

endmodule
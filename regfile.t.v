//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------
`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
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

  // loop index
  integer index;

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 != 42) || (ReadData2 != 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2: 
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 != 15) || (ReadData2 != 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end


  //--------Deliverable 8---------

  // 1

  // Test Case 1:
  //   Write maximum value to all register. Then check the value of them
  WriteData = 32'hFFFFFFFF;
  RegWrite = 1;
  for(index=1;index<32;index=index+1) begin
    WriteRegister = index;
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;
    
    if((ReadData1 != 4294967295) || (ReadData2 != 4294967295)) begin
      dutpassed = 0;
      $display("Type 1 Test Case 1 Failed");
    end
  end


  // 2. Write Enable is broken / ignored – Register is always written to.

  // Test Case 1:
  //   After writing '1955103904 - 10*(register number)' to a register, disenable RegWrite.
  //   Then try to write '3410 + (register number)*(register number)' to the register. Repeat for all register. 
  
  for(index=1;index<32;index=index+1) begin
    WriteRegister = index;
    WriteData = 32'd1955103904 - 10*index;
    RegWrite = 1;
    #5 Clk=1; #5 Clk=0;
    RegWrite = 0;
    WriteData = 32'd3410 + index*index;
    #5 Clk=1; #5 Clk=0;
    ReadRegister1 = index;
    ReadRegister2 = index;
    if((ReadData1 != 1955103904 - 10*index) || (ReadData2 != 1955103904 - 10*index)) begin
      dutpassed = 0;
      $display("Type 2 Test Case 1 Failed: A register changes while Write Enable is off");
    end
  end


  // 3. Decoder is broken – All registers are written to.

  // Test Case 1:
  //   After reset all register to zero, write '795546904 - 34*(register number)' to all register. Then check the value of each register
  
  // Reset all register to zero
  RegWrite = 1;
  WriteData = 0;  
  for(index=1;index<32;index=index+1) begin
    WriteRegister = index;
    #5 Clk=1; #5 Clk=0;
  end

  for(index=1;index<32;index=index+1) begin
    WriteRegister = index;
    WriteData = 32'd795546904 - 34*index;
    #5 Clk=1; #5 Clk=0;
  end

  for(index=1;index<32;index=index+1) begin
    ReadRegister1 = index;
    ReadRegister2 = index;
    if((ReadData1 != (795546904 - 34*index)) || (ReadData2 != (795546904 - 34*index))) begin
      dutpassed = 0;
      $display("Type 3 Test Case 1 Failed: Decoder is broken");
    end
  end

  // Test Case 2:
  //   Write '8193' to register 13, '4294901760' to register 31, and '15793935' to register 16.
  //   Then Check the value of register 1, 13, 16, 31
  WriteRegister = 5'd13;
  WriteData = 32'd8193;
  #5 Clk=1; #5 Clk=0;
  WriteRegister = 5'd31;
  WriteData = 32'd4294901760;
  #5 Clk=1; #5 Clk=0;
  WriteRegister = 5'd16;
  WriteData = 32'd15793935;
  #5 Clk=1; #5 Clk=0;

  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd13;
  if((ReadData1 != 795546870) || (ReadData2 != 8193)) begin
    dutpassed = 0;
    $display("Type 3 Test Case 2 Failed: Decoder is broken");
  end

  ReadRegister1 = 5'd16;
  ReadRegister2 = 5'd31;
  if((ReadData1 != 15793935) || (ReadData2 != 4294901760)) begin
    dutpassed = 0;
    $display("Type 3 Test Case 2 Failed: Decoder is broken");
  end




  // 4. Register Zero is actually a register instead of the constant value zero.

  // Test Case 1:
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;
    $display("Type 4 Test Case 1 Failed: Zero register has a non-zero value.");
  end


  // Test Case 2:
  //   Write '3410' to register 0, check its value changes 
  WriteRegister = 5'd0;
  WriteData = 32'd3410;
  RegWrite = 1;
  #5 Clk=1; #5 Clk=0;
  
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;
    $display("Type 4 Test Case 2 Failed: Zero register has a non-zero value");
  end

  // Test Case 3:
  //   Write '47186640' to register 0, check its value changes
  WriteData = 32'd47186640;
  #5 Clk=1; #5 Clk=0;
  
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;
    $display("Type 4 Test Case 3 Failed: Zero register has a non-zero value");
  end


  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
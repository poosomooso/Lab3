`include "datamemory.v"

module datamemory_test();
	reg 		clk;
    wire [31:0] dataOut;
    reg [31:0]  address;
    reg         writeEnable;
    reg [31:0]  dataIn;

	datamemory datamem(.clk(clk), .dataOut(dataOut), 
		.address(address), .writeEnable(writeEnable),
		.dataIn(dataIn));


    // Clock generation
    initial clk=1;
    always #10 clk = !clk;

	// Test sequence - try writing 2 different values an reading to make sure they were written properly
    // and then inputing a value while writeEnable is low to make sure writeEnable is working properly
    initial begin

    address = 32'd0; dataIn = 32'd1234; writeEnable = 1'b1; #40 //give it enough time for 1 clock cycle
    if (dataOut != 32'd1234) $display("Test 1 failed");

    address = 32'd1234; dataIn = 32'd4321; writeEnable = 1'b1; #40
    if (dataOut != 32'd4321) $display("Test 2 failed");

    address = 32'd1234; dataIn = 32'd5678; writeEnable = 1'b0; #40
    if (dataOut != 32'd4321) $display("Test 3 failed");

    // End execution so that it doesn't got on forever
    #1000 $finish();
    end

endmodule
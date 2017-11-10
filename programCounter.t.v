`timescale 1 ns / 1 ps
`include "programCounter.v"

module testProgramCounter ();

	wire[31:0] currentCount;
    wire[3:0] lastFourBits;
	reg[31:0] newCount;
	reg write;
	reg clk;

	programCounter dut(currentCount, lastFourBits, newCount, write, clk);

    initial clk=1;
    initial write=1;
    always #10 clk=!clk;

	initial begin
    $dumpfile("programCounter.vcd");
    $dumpvars(0,testProgramCounter);
    // initialization
    $display("newCount | currentCount lastFourBits");
    newCount=32'h12;#30
    $display("%b    %b | %b", newCount, currentCount, lastFourBits);
    newCount=32'hCD0123AB; #30
    $display("%b    %b | %b", newCount, currentCount, lastFourBits);
    end

endmodule

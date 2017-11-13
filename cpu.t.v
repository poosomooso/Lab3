`timescale 1 ns / 1 ps
`include "cpu.v"

module testCpu();
    reg clk;

    cpu dut(clk);

    initial clk=0;
    always #10 clk=!clk;

    initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,testCpu);
    $display("Test running. Check waveform for the result.");
    end

endmodule

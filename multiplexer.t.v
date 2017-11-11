`timescale 1 ns / 1 ps
`include "multiplexer.v"

module testMux2input();
    reg addr;
    reg[31:0] in[31:0];
    wire[31:0] out1, out2, out3;

    mux2input mux(out1, addr, in[0], in[1]);
    mux4input mux(out2, addr, in[0], in[1], in[2], in[3]);

    initial begin

    $display("addr inputs                           | Output");
    $display("Test multiplexer with 2 inputs");
    addr=0; in[0]=32'hFFFFFFFF;in[1]=32'h00000000; #1000
    $display("%b    %b | %b", addr, in[0], out1);
    addr=1; in[0]=32'h144CAB32;in[1]=32'hA3C972C4; #1000
    $display("%b    %b | %b", addr, in[1], out1);
    addr=1; in[0]=32'h55555555;in[1]=32'hAAAAAAAA; #1000
    $display("%b    %b | %b", addr, in[1], out1);
    addr=0; in[0]=32'h18ED932B;in[1]=32'h714A0DC2; #1000
    $display("%b    %b | %b", addr, in[0], out1);
    
    $display("Test multiplexer with 4 inputs");
    
    end

endmodule
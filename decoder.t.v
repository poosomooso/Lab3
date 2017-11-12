`timescale 1 ns / 1 ps
`include "decoder.v"

module testDecoders ();

	wire[31:0] out;
    reg enable;
    reg[4:0] address;

	decoder decode(out, enable, address);

	initial begin
    $display("address enable | out                               | Expected Output");
    address=0;enable=0; #1000 
    $display("%b   %b      | %b  | 00000000000000000000000000000000", address, enable, out);
    address=1;enable=1; #1000 
    $display("%b   %b      | %b  | 00000000000000000000000000000010", address, enable, out);
    address=10;enable=1; #1000 
    $display("%b   %b      | %b  | 00000000000000000000010000000000", address, enable, out);
    address=15;enable=0; #1000 
    $display("%b   %b      | %b  | 00000000000000000000000000000000", address, enable, out);
    end

endmodule
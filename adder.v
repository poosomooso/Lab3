// Adder circuit

module structuralFullAdder
(
    output sum,
    output carryout,
    input a, 
    input b, 
    input carryin
);

    wire ab;
    xor aXORb(ab, a, b);
    xor abXORc(sum, ab, carryin);

    wire aAndb, oneAndC;
    and aANDb(aAndb, a, b);
    and aXORbANDc(oneAndC, ab, carryin);
    or aorborc(carryout, aAndb, oneAndC);
    
endmodule

module FullAdder32bit
(
  output[31:0] sum,
  output carryout,
  output overflow,
  input[31:0] a,
  input[31:0] b
);
    wire[31:0] carry;
    wire[31:0] over;
    assign carry[0] = 1'b0;
    genvar i;
    generate
        for (i=0; i<31; i=i+1)begin : add_block
            structuralFullAdder add0 (sum[i], carry[i+1], a[i], b[i], carry[i]);
        end
    endgenerate
    structuralFullAdder add0 (sum[31], carryout, a[31], b[31], carry[31]);
    xor overflowCheck(overflow, carry[31], carryout);
endmodule

module Subtractor32bit
(
  input[31:0] a, b,
  output[31:0] sum,
  output carryout, overflow
);

    wire[31:0] notb, b2comp;
    wire unusedCarryout, invertingOverflow, totalOverflow;

    not32 notbgate (notb, b);
    FullAdder32bit add1tob(b2comp, unusedCarryout, invertingOverflow, notb, 32'd1);
    FullAdder32bit getsum(sum, carryout, totalOverflow, a, b2comp);
    or overflowgate(overflow, totalOverflow, invertingOverflow);
endmodule
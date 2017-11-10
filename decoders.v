// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address; 

endmodule

// Deliveriable 6
//   In the above code, the value of 'out' is assigned to the value of that the enable bit is shifted
// 'address' bits in the left direction.
// If 'enable' is 0(decoder is disabled), 'out' is always 32-bit zero. So all output bit is inactive.
// If 'enable' is 1(decoder is enabled), 'out' is the 32-bit value of which ('address'+1)-th bit is 1
// and other bits are 0. So only the bit which is selected by 'address' value is active.
//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module dff
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               ce,
input  [width-1:0]  dataIn,     // Load shift reg in parallel
output [width-1:0]  dataOut     // Shift reg data contents
);

    reg [width-1:0]      mem;
    always @(posedge clk) begin
        if (ce == 1)
            mem <= dataIn;
    end
    assign dataOut = mem[width-1:0];

endmodule

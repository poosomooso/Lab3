
module PCReg
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               ce,
input  [width-1:0]  dataIn,     // Load shift reg in parallel
output [width-1:0]  dataOut     // Shift reg data contents
);

    reg [width-1:0]     mem;
    reg [width-1:0]     zero;

    initial begin
        mem <= {(width) {1'b0}};
    end

    always @(posedge clk) begin
        $display("pc: %b",dataOut);
        if (ce == 1)
            mem <= dataIn;
    end
    assign dataOut = mem[width-1:0];

endmodule

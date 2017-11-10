//Program counter for a cpu, implemented as a 32-bit d flip flop
module program_counter
(
output reg[31:0]    q,
output reg[3:0]     last_four,
input[31:0]         d,
input               wrenable,
input               clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
            last_four = d[31:28];
        end
    end

endmodule

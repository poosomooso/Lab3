module signextend(a, result);

parameter INPUT_SIZE = 16;
parameter OUTPUT_SIZE = 32;

input [INPUT_SIZE-1:0] a; // 16-bit input
output [OUTPUT_SIZE-1:0] result; // 32-bit output

assign result = {{OUTPUT_SIZE-INPUT_SIZE{a[INPUT_SIZE-1]}},a};

endmodule
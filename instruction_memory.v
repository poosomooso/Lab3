module instruction_memory
(
	input clk, regWE,
	input[31:0] Addr,
	input[31:0] DataIn,
	output[31:0] DataOut
);

	reg [31:0] mem[1023:0];
	
	always@(posedge clk) begin
		if (regWE) begin
			mem[Addr] <= DataIn;
		end
		
	end
	
	initial begin
		$readmemh("mem.dat",mem);
	end
	
		assign DataOut = mem[Addr>>2];
endmodule
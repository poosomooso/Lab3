`include "cpu.v"

module cputest();

reg clk;
wire[1023:0] registers;

CPU dut(.clk(clk), .registers(registers));

initial clk=0;
always #5 clk=!clk;

initial begin
	
	#100

	$display("%b", registers);

	$finish;
end
endmodule
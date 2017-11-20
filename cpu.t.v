`include "cpu.v"

module cputest();

reg clk;
wire[1023:0] registers;

CPU dut(.clk(clk), .registers(registers));

initial clk=0;
always #10 clk=!clk;

wire[31:0] registers2d[31:0];

genvar i;
generate for (i=0; i<32; i=i+1) begin : unpack_reg
	assign registers2d[i][31:0] = registers[((32)*i+(31)):((32)*i)];
end
endgenerate

integer j;
initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,dut);

	#500

    for (j=0; j<32; j=j+1) begin
        $display("reg %d : %h", j, registers2d[j]);
    end

	$finish;
end
endmodule
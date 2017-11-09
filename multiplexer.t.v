module testMux2input();
    reg addr;
    reg[31:0] in0;
    reg[31:0] in1;
    wire out;

    Mux2input mux(out, addr, in0, in1);

    initial begin
    $display("addr inputs        | Output");
    addr=0; in0=32'hFFFF;in1=32'h0000; #1000
    $display("%b    %b | %b", addr, in0, out);
    addr=1; in0=32'hAB32;in1=32'h72C4; #1000
    $display("%b    %b | %b", addr, in1, out);
    addr=1; in0=32'h5555;in1=32'hAAAA; #1000
    $display("%b    %b | %b", addr, in1, out);
    addr=0; in0=32'h932B;in1=32'h0DC2; #1000
    $display("%b    %b | %b", addr, in0, out);
    end

endmodule
module fourToOneMux #(parameter DATA_WIDTH = 32) (out,in1,in2,in3,in4,slt);
    output [DATA_WIDTH-1:0] out;
    input [DATA_WIDTH-1:0] in1,in2,in3,in4;
    input [1:0] slt;
    
    reg [DATA_WIDTH-1:0] out;
    
    always @ (*) begin
        case(slt)
            2'b00:out = in1;
            2'b01:out = in2;
            2'b10:out = in3;
            2'b11:out = in4;
        endcase
        // if (in4 == 32'd10)
        //     $display("4to1: %h %h %h %h --- %h",in1,in2,in3,in4, out);
    end
endmodule

module twoToOneMux #(parameter DATA_WIDTH = 32) (out,in1,in2,slt);
    output [DATA_WIDTH-1:0] out;
    input [DATA_WIDTH-1:0] in1,in2;
    input slt;
    
    assign out = slt ? in2 : in1;
    // always @(*) begin
    //     $display("2to1: %h %h --- %h",in1,in2, out);
    // end
endmodule

module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);
  assign out = inputs[address];
endmodule

module mux32to1by32
(
output reg[31:0]  out,
input[4:0]    address,
input[31:0]   input0, input1, input2, input3,
                input4, input5, input6, input7,
                input8, input9, input10, input11, 
                input12, input13, input14, input15, 
                input16, input17, input18, input19, 
                input20, input21, input22, input23, 
                input24, input25, input26, input27, 
                input28, input29, input30, input31
);

    wire[31:0] mux[31:0];           // Create a 2D array of wires
    assign mux[0] = input0;     // Connect the sources of the array
    assign mux[1] = input1;
    assign mux[2] = input2;
    assign mux[3] = input3;
    assign mux[4] = input4;
    assign mux[5] = input5;
    assign mux[6] = input6;
    assign mux[7] = input7;
    assign mux[8] = input8;
    assign mux[9] = input9;
    assign mux[10] = input10;
    assign mux[11] = input11;
    assign mux[12] = input12;
    assign mux[13] = input13;
    assign mux[14] = input14;
    assign mux[15] = input15;
    assign mux[16] = input16;
    assign mux[17] = input17;
    assign mux[18] = input18;
    assign mux[19] = input19;
    assign mux[20] = input20;
    assign mux[21] = input21;
    assign mux[22] = input22;
    assign mux[23] = input23;
    assign mux[24] = input24;
    assign mux[25] = input25;
    assign mux[26] = input26;
    assign mux[27] = input27;
    assign mux[28] = input28;
    assign mux[29] = input29;
    assign mux[30] = input30;
    assign mux[31] = input31;
    
      // Connect the output of the array

    always @(*) begin
        out = mux[address];
        // $display("zero: %h %h",mux[0], input0);
        // $display("address %h",address);
        // $display("muxout %h",out);

    end
endmodule
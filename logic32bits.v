// define gates with delays


module nand32(
    output[31:0] out,
    input[31:0] a,b
);

    genvar i;
    generate
        for (i=0; i<32; i=i+1)begin : nand_block
            nand bit_nand(out[i],a[i],b[i]);
        end
    endgenerate

endmodule

module nor32(
    output[31:0] out,
    input[31:0] a,b
);

    genvar i;
    generate
        for (i=0; i<32; i=i+1)begin : nor_block
            nor bit_nor(out[i],a[i],b[i]);
        end
    endgenerate

endmodule



module not32(

    output[31:0] out,
    input[31:0] a
);

    genvar i;
    generate
        for (i=0; i<32; i=i+1)begin : not_block
            not bit_not(out[i],a[i]);
        end
    endgenerate

endmodule

module and32 (
    output[31:0] out,
    input[31:0] a,b
);
    wire[31:0] nand_out;
    nand32 nandgate (nand_out, a, b);
    not32 notgate (out, nand_out);

endmodule

module or32 (
    output[31:0] out,
    input[31:0] a,b
);
    wire[31:0] nor_out;
    nor32 norgate (nor_out, a, b);
    not32 notgate (out, nor_out);

endmodule

module xor32(
    output[31:0] out,
    input[31:0] a,b
);
    genvar i;
    generate
        for (i=0; i<32; i=i+1)begin : xor_block
            xor bit_xor(out[i],a[i],b[i]);
        end
    endgenerate

endmodule

module zero_check(
    output out,
    input[31:0] check
);
    wire[30:0] carry_out;

    or or0(carry_out[0], check[0], check[1]);

    genvar i;
    generate
        for (i=0; i<30; i=i+1)begin : or_block
            or bit_or(carry_out[i+1], check[i+2], carry_out[i]);
        end
    endgenerate

    not invert(out, carry_out[30]);

endmodule
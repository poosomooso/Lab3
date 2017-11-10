`timescale 1 ns / 1 ps
`include "adder.v"

module testAdderr ();

	wire sum;
	wire cout;
    reg a;
    reg b;
    reg cin;

	adder1bit adder(sum, cout, a, b, cin);

	initial begin
    $display("a b cin | sum cout | Expected Output");
    a=0;b=0;cin=0; #1000 
    $display("%b %b %b   |  %b    %b  | All false", a, b, cin, sum, cout);
    a=0;b=1;cin=0; #1000
    $display("%b %b %b   |  %b    %b  | sum Only", a, b, cin, sum, cout);
    a=0;b=0;cin=1; #1000 
    $display("%b %b %b   |  %b    %b  | sum Only", a, b, cin, sum, cout);
    a=0;b=1;cin=1; #1000 
    $display("%b %b %b   |  %b    %b  | cout Only", a, b, cin, sum, cout);
    a=1;b=0;cin=0; #1000 
    $display("%b %b %b   |  %b    %b  | sum Only", a, b, cin, sum, cout);
    a=1;b=1;cin=0; #1000 
    $display("%b %b %b   |  %b    %b  | cout Only", a, b, cin, sum, cout);
    a=1;b=0;cin=1; #1000 
    $display("%b %b %b   |  %b    %b  | cout Only", a, b, cin, sum, cout);
    a=1;b=1;cin=1; #1000 
    $display("%b %b %b   |  %b    %b  | All true", a, b, cin, sum, cout);
    end

endmodule
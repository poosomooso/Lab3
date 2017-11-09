module testAdderr ();

	wire sum;
	wire cout;
    wire a;
    wire b;
    wire cin;

	adder1bit adder(sum, cout, a, b, cin);

	initial begin
    clk=0; write=0; #5
    $display("a b cin | sum cout | Expected Output");
    a=0;b=0;carryin=0; #1000 
    $display("%b %b %b  |   %b    %b | All false", a, b, carryin, sum, carryout);
    a=0;b=1;carryin=0; #1000
    $display("%b %b %b  |   %b    %b | sum Only", a, b, carryin, sum, carryout);
    a=0;b=0;carryin=1; #1000 
    $display("%b %b %b  |   %b    %b | sum Only", a, b, carryin, sum, carryout);
    a=0;b=1;carryin=1; #1000 
    $display("%b %b %b  |   %b    %b | carryout Only", a, b, carryin, sum, carryout);
    a=1;b=0;carryin=0; #1000 
    $display("%b %b %b  |   %b    %b | sum Only", a, b, carryin, sum, carryout);
    a=1;b=1;carryin=0; #1000 
    $display("%b %b %b  |   %b    %b | carryout Only", a, b, carryin, sum, carryout);
    a=1;b=0;carryin=1; #1000 
    $display("%b %b %b  |   %b    %b | carryout Only", a, b, carryin, sum, carryout);
    a=1;b=1;carryin=1; #1000 
    $display("%b %b %b  |   %b    %b | All true", a, b, carryin, sum, carryout);
    end

endmodule
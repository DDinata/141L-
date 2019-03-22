module sandbox();

wire [ 9:0] PC;
logic [3:0] l = 4'b1011;
logic [3:0] x = 4'b0010;
logic [3:0] a = 4'b0110;
logic [3:0] b = 4'b0010;
logic [3:0] c = 4'b0001;

initial begin
$display("pc: %b", PC);

$display("L: %b", l);

l = 2'b00;
$display("L: %b", l);

$display("b: %1d", 0 ? 8 : 9);
$display("b: %1d", 1 ? 8 : 9);

$display("x : %b", x);
$display("x val: %x", x);
$display("x complement: %b", ~x);
$display("x complement val: %x", ~x);

$display("a-b-c: %b", a-b-c);

end

endmodule

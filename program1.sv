module program1();

logic[63:0] dividend = 64'h8000_0000_0000_0000;
logic[15:0] divisor;
logic[63:0] quotient1;
logic[15:0] result;
real quotientR;

initial begin
  #1 divisor = 16'h0001;
  #1 div1;

  #10 divisor = 16'h0003;
  #1 div1;

  #10 divisor = 16'h0004;
  #1 div1;

  #10 divisor = 16'h0005;
  #1 div1;

  #10 divisor = 16'h3333;
  #1 div1;

  #10 divisor = 16'h4000;
  #1 div1;

  #10 divisor = 16'h8000;
  #1 div1;
  #10 $stop;
end


task automatic div1;
  quotient1 = dividend/divisor;
  result = quotient1[63:48]+quotient1[47];                                  // half-LSB upward rounding
  quotientR = 1.00000/$itor(divisor);
  $display ("dividend = %h, divisor = %h, quotient = %h, result = %h, equiv to %10.5f",dividend, divisor, quotient1, result, quotientR); 
endtask

endmodule






									   
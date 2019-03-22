module program2();
logic[15:0] div_in;
logic[63:0] dividend;
logic[7:0] divisor;
logic[63:0] quotient1;
logic[23:0] result;
real quotientR;

initial begin
  #1 div_in = 16'h0001;
     divisor = 8'h01;
  #1 div1;

  #10 divisor = 8'h03;
  #1 div1;

  #10 divisor = 8'h04;
  #1 div1;

  #10 divisor = 8'h05;
  #1 div1;

  #10 div_in = 8'h0f;
  #1 div1;

  #10 divisor = 8'h33;
  #1 div1;

  #10 divisor = 8'h40;
  #1 div1;

  #10 divisor = 8'h80;
  #1 div1;

  #10 div_in = 16'hffff;
  #10 divisor = 8'h02;
  #1 div1;

  #10 div_in = 16'h0002;
  #10 divisor = 8'hff;
  #1 div1;

  #10 div_in = 16'h3fe6;
  #10 divisor = 8'h6a;
  #1 div1;

  #10 div_in = 16'h2121;
  #10 divisor = 8'h43;
  #1 div1;

  #10 div_in = 16'h0007;
  #10 divisor = 8'h03;
  #1 div1;

  #10 div_in = 16'h0003;
  #10 divisor = 8'h07;
  #1 div1;

  #10 div_in = 16'h0004;
  #10 divisor = 8'h07;
  #1 div1;

  #10 $stop;
end


task automatic div1;
  dividend = div_in<<48;
  quotient1 = dividend/divisor;
  result = quotient1[63:40]+quotient1[39];                                  // half-LSB upward rounding
  quotientR = $itor(div_in)/$itor(divisor);
  $display ("dividend = %h, divisor = %h, quotient = %h, result = %h, equiv to %10.5f",dividend, divisor, quotient1, result, quotientR);
endtask

endmodule

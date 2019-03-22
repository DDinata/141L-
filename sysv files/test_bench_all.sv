// CSE141L  Winter 2019
// test bench to be used to verify student projects
// pulses start while loading program 1 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 2 operands into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 3 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation

module test_bench_all();

logic clk, 		           // system clock runs test bench and DUT
      start;               // request to DUT
wire  done;			       // acknowledge back from DUT

// your design goes here
// *** change device and port names as needed ***
TopLevel d1(.CLK(clk), .start(start), .halt(done));

// program 1 variables
logic[63:0] dividend;      // fixed for pgm 1 at 64'h8000_0000_0000_0000;
logic[15:0] divisor1;	   // divisor 1 (sole operand for 1/x) to DUT
logic[63:0] quotient1;	   // internal wide-precision result
logic[15:0] result1,	   // desired final result, rounded to 16 bits
            result1_DUT;   // actual result from DUT
real quotientR;			   // quotient in $real format
// program 2 variables
logic[15:0] div_in2;	   // dividend 2 to DUT
logic[ 7:0] divisor2;	   // divisor 2 to DUT
logic[23:0] result2,	   // desired final result, rounded to 24 bits
            result2_DUT;   // actual result from DUT
// program 3 variables
logic[15:0] dat_in3;	   // operand to DUT
logic[ 7:0] result3;	   // expected SQRT(operand) result from DUT
logic[47:0] square3;	   // internal expansion of operand
logic[ 7:0] result3_DUT;   // actual SQRT(operand) result from DUT
real argument, result, 	   // reals used in test bench square root algorithm
     error, result_new;
// clock -- controls all timing, data flow in hardware and test bench
always begin
       clk = 0;
  #5ns clk = 1;
  #5ns;
end

initial begin
// initialize register file to 00
  for(int j=0; j<16; j++)
    d1.reg_file1.registers[j] = 8'b0;    // default -- clear it
// launch program 1
  start = 1;
  dividend = 64'h8000_0000_0000_0000;
  divisor1 = 1;//3;            // *** try various values here ***
// your memory gets loaded here
// *** change names of memory or its guts as needed ***
  d1.data_mem1.core[8] = divisor1[15:8];
  d1.data_mem1.core[9] = divisor1[ 7:0];
  if(divisor1) div1;										// logical value of nonzero vector = 1;
  else result1 = '1;    // 1/0 = all 1's (maximum value; "saturating logic")
  #20ns start = 0;
  #20ns wait(done);
// your memory gets read here
// *** change names of memory or its guts as needed ***
  result1_DUT[15:8] = d1.data_mem1.core[10];
  result1_DUT[ 7:0] = d1.data_mem1.core[11];
  $display ("divisor = %h, quotient = %h, result1 = %h, equiv to %10.5f",
    divisor1, quotient1, result1, quotientR);
  if(result1==result1_DUT) $display("success -- match1");
  else $display("OOPS1! expected %h, got %h",result1,result1_DUT);
// preload operands and launch program 2
  #10ns start = 1;
// insert dividend and divisor
  div_in2 = 16'h0001;	   // *** try various values here ***
  divisor2 = 0;//8'h03;		   // *** try various values here ***
// *** change names of memory or its guts as needed ***
  d1.data_mem1.core[0] = div_in2[15:8];
  d1.data_mem1.core[1] = div_in2[ 7:0];
  d1.data_mem1.core[2] = divisor2;
  if(divisor2) div2; 							             // divisor2 is "true" only if nonzero
  else result2 = '1; // same as program 1: limit to max.
  #20ns start = 0;
  #20ns wait(done);
// *** change names of memory or its guts as needed ***
  result2_DUT[23:16] = d1.data_mem1.core[4];
  result2_DUT[15: 8] = d1.data_mem1.core[5];
  result2_DUT[ 7: 0] = d1.data_mem1.core[6];
  $display ("dividend = %h, divisor2 = %h, quotient = %h, result2 = %h, equiv to %10.5f",
    dividend, divisor2, quotient1, result2, quotientR);
  if(result2==result2_DUT) $display("success -- match2");
  else $display("OOPS2! expected %h, got %h",result2,result2_DUT);
// preload operands and launch program 3
  #10ns start = 1;
// insert operand
  dat_in3 = 0;//65535;		   // *** try various values here ***
// *** change names of memory or its guts as needed ***
  d1.data_mem1.core[12] = dat_in3[15: 8];
  d1.data_mem1.core[13] = dat_in3[ 7: 0];
  if(dat_in3==0) result3 = 0;   // trap 0 case up front
  else div3;
  #20ns start = 0;
  #20ns wait(done);
// *** change names of memory or its guts as needed ***
  result3_DUT = d1.data_mem1.core[14];
  $display("operand = %h, sqrt = %h",dat_in3,result3);
  if(result3==result3_DUT) $display("success -- match3");
  else $display("OOPS3! expected %h, got %h",result3,result3_DUT);
  #10ns $stop;
end

task automatic div1;
  quotient1 = dividend/divisor1;
  result1 = quotient1[63:48]+quotient1[47];                                  // half-LSB upward rounding
  quotientR = 1.00000/$itor(divisor1);
endtask

task automatic div2;
  dividend = div_in2<<48;
  quotient1 = dividend/divisor2;
  result2 = quotient1[63:40]+quotient1[39];                                  // half-LSB upward rounding
  quotientR = $itor(div_in2)/$itor(divisor2);
//  $display ("dividend = %h, divisor2 = %h, quotient = %h, result2 = %h, equiv to %10.5f",dividend, divisor2, quotient1, result2, quotientR);
endtask

task automatic div3;
  argument = $itor(dat_in3);
//  real error, result_new;
  result = 1.0;
  error = 1.0;
  while (error > 0.001) begin
    result_new = argument/2.0/result + result/2.0;
    error = (result_new - result)/result;
    if (error < 0.0) error = -error;
      result = result_new;
  end
  result3 = $rtoi(result);
  if(!(&(result3)))
    result3 = $rtoi(result+0.5);
endtask

endmodule

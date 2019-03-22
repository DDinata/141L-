module program3();

logic[15:0] dat_in;
logic[ 7:0] dat_out;
logic[47:0] square;
real argument,result, error, result_new;

initial begin
  dat_in = 3;
  calculate_sqrt;

  dat_in = 255;
  calculate_sqrt;

  dat_in = 65;
  calculate_sqrt;

  dat_in = 16383;
  calculate_sqrt;

  dat_in = 65240;
  calculate_sqrt;

  dat_in = 65241;
  calculate_sqrt;

  dat_in = 65535;
  calculate_sqrt;

  dat_in = 240;
  calculate_sqrt;

  dat_in = 241;
  calculate_sqrt;

  dat_in = 65281;
  calculate_sqrt;

  dat_in = 65280;
  calculate_sqrt;

  $stop;
end

task calculate_sqrt;
  argument = $itor(dat_in);
//  real error, result_new;
  result = 1.0;
  error = 1.0;
  while (error > 0.001) begin
    result_new = argument/2.0/result + result/2.0;
    error = (result_new - result)/result;
    if (error < 0.0) error = -error;
      result = result_new;
  end
  dat_out = $rtoi(result+0.5);
  $display(dat_in,,,dat_out);
endtask

endmodule

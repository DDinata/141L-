module PC3(
  input      clk,
             init, 
  input[1:0] jump,
             branch,
  output logic[9:0] PC );

  logic[9:0] PC_incr,
             PC_next;

// LUT
  always_comb case(branch)
    0: PC_next = PC+1;
	1: PC_next = 50;
	2: PC_next = 100;
	3: PC_next = 200; 
  endcase

  always_comb case(jump)   // relative
    0: PC_incr = 1;
    1: PC_incr = 5;
	2: PC_incr = -5;
	3: PC_incr = 25;
  endcase  

  always @(posedge clk)
    if(init)
	  PC <= 0;
    else if(branch)
	  PC <= PC_next;
	else if(jump)
	  PC <= PC + PC_incr;
	else
	  PC <= PC + 1;

endmodule
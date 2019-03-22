// Create Date:    15:50:22 10/02/2016
// Design Name:
// Module Name:    InstROM
// Project Name:   CSE141L
// Tool versions:
// Description: Verilog module -- instruction ROM template
//	 preprogrammed with instruction values (see case statement)
//
// Revision:
//
module InstROM (
  input       [9:0] InstAddress,
  output logic[8:0] InstOut);
  logic[8:0] inst_rom[2**(10)];
  always_comb InstOut = inst_rom[InstAddress];

  initial begin		                  // load from external text file
  	$readmemb("machine_code",inst_rom);
  end

endmodule

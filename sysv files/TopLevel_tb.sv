// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module TopLevel_tb;	     // Lab 17

// To DUT Inputs
  bit start;
  bit CLK;

// From DUT Outputs
  wire halt;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
	start           ,
	CLK             ,
	halt
	);

initial begin
  start = 1;
// Initialize DUT's data memory
  #10ns for(int i=0; i<256; i++) begin
    DUT.data_mem1.core[i] = 8'h0;	     // clear data_mem

    // p1 input
    DUT.data_mem1.core[8] = 8'h00;
    DUT.data_mem1.core[9] = 8'h00;

    // p2 input
    DUT.data_mem1.core[0] = 8'h00;
    DUT.data_mem1.core[1] = 8'h04;
    DUT.data_mem1.core[2] = 8'h07;

    // p3 input
    {DUT.data_mem1.core[12], DUT.data_mem1.core[13]} = 65535;

  end
// students may also pre_load desired constants into data_mem
// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.reg_file1.registers[j] = 8'b0;    // default -- clear it
// students may pre-load desired constants into the reg_file

// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  wait (halt);
  start = 1;
  #10ns $display("p1 input h: %h %h", DUT.data_mem1.core[8], DUT.data_mem1.core[9]);
  #10ns $display("p1 output h: %h %h", DUT.data_mem1.core[10], DUT.data_mem1.core[11]);
  // #10ns $display("p1 input b: %b %b", DUT.data_mem1.core[8], DUT.data_mem1.core[9]);
  // #10ns $display("p1 output b: %b %b", DUT.data_mem1.core[10], DUT.data_mem1.core[11]);

  #100ns $display("p2 input h: %h %h %h", DUT.data_mem1.core[0], DUT.data_mem1.core[1], DUT.data_mem1.core[2]);
  #100ns $display("p2 output h: %h %h %h", DUT.data_mem1.core[4], DUT.data_mem1.core[5], DUT.data_mem1.core[6]);
  // #100ns $display("p2 input b: %b %b %b", DUT.data_mem1.core[0], DUT.data_mem1.core[1], DUT.data_mem1.core[2]);
  // #100ns $display("p2 output b: %b %b %b", DUT.data_mem1.core[4], DUT.data_mem1.core[5], DUT.data_mem1.core[6]);

  #100ns $display("p3 input d: %d", {DUT.data_mem1.core[12],DUT.data_mem1.core[13]});
  #100ns $display("p3 output d: %d", DUT.data_mem1.core[14]);
  // #100ns $display("p3 output h: %h", DUT.data_mem1.core[14]);
  // #100ns $display("p3 output b: %b", DUT.data_mem1.core[14]);

  // #100ns $display("instruction = %d %t",DUT.PC,$time);
  #10ns $stop;
end

always begin   // clock period = 10 Verilog time units
  #5ns  CLK = 1;
  #5ns  CLK = 0;
end

endmodule

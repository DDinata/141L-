// single address pointer for both read and write
module data_mem(
  input              CLK,
  input              reset,
  input [7:0]        DataAddress,
  input              ReadMem,
  input              WriteMem,
  input [7:0]        DataIn,
  output logic[7:0]  DataOut);

  logic [7:0] core[256];

//  initial
//    $readmemh("dataram_init.list", my_memory);

  // combinational reads
  always_comb begin
    if (ReadMem) DataOut = core[DataAddress];
    else DataOut = 'bZ;           // tristate, undriven
  end

  // sequential writes
  always_ff @ (posedge CLK) begin
    if(reset) begin
      // you may initialize your memory w/ constants, if you wish
      // for(int i=0;i<256;i++)
  	    // core[i] <= 0;
  	end
    else if (WriteMem) begin
      core[DataAddress] <= DataIn;
  	  // $display("Memory write M[%d] = %d (%b)",DataAddress,DataIn,DataIn);
      // $display("----------------------------------------------");
    end
    else if (ReadMem) begin
      // $display("----------------------------------------------");
      // $display("Memory read M[%d] = %d (%b)",DataAddress,DataOut,DataOut);
    end
  end

endmodule

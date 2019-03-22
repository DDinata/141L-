import definitions::*;

module reg_file (		 // W = data path width; D = pointer width
  input           CLK,
                  init,

  input  [3:0]    RegSrc1,
                  RegSrc2,
                  RegDest,

  input  [7:0]    WriteInput,
  input           WriteReg,
                  CarryOutValue,

  output logic [7:0] Out1, Out2,
  output logic    CarryInValue,

  output logic [7:0] BranchAmount,
  output logic    BranchDirection
);

logic [7:0] registers[16];

// combinational read
always_comb begin
  Out1 = registers[RegSrc1];
  Out2 = registers[RegSrc2];
  CarryInValue = registers[R_Bits][CarryInBit];
  BranchAmount = registers[R_BranchTarget];
  BranchDirection = registers[R_Accumulator][0];
end

// sequential writes
always_ff @ (posedge CLK) begin
  // $display("Reg Out1: R[%d] -> %d (%b)", RegSrc1, Out1, Out2);
  // $display("Reg Out2: R[%d] -> %d (%b)", RegSrc2, Out2, Out2);
  // for (int i=0;i<16;i++) $display("R[%2d]: %b", i, registers[i]);
  if (WriteReg) begin
    registers[RegDest] <= WriteInput;
    // $display("Reg Write: R[%d] = %d (%b)", RegDest, WriteInput, WriteInput);
    // $display("----------------------------------------------");
  end
  registers[R_Bits][CarryOutBit] <= CarryOutValue;
end

endmodule

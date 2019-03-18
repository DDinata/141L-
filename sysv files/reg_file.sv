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
  output logic [7:0] Out1,
  output logic [7:0] Out2,
  output logic    CarryInValue,
  output logic    BranchDir,
  output logic [7:0] BranchTargetRegister
);

logic [7:0] registers[16];

always_comb Out1 = registers[RegSrc1];
always_comb Out2 = registers[RegSrc2];
always_comb CarryInValue = registers[R_Bits][CarryInBit];
always_comb BranchTargetRegister = registers[R_BranchTarget];
always_comb BranchDir = registers[R_Bits][BranchDirBit];

always_ff @ (posedge CLK) begin
$display("--REG FILE--");
$display("R_0: %b", registers[0]);
$display("R_1: %b", registers[1]);
$display("R_15: %b", registers[15]);
$display("RegSrc1: %b", RegSrc1);
$display("RegSrc2: %b", RegSrc2);
$display("RegDest: %b", RegDest);
$display("Write Input: %b", WriteInput);
$display("---------");
end

// sequential (clocked) writes
always_ff @ (posedge CLK) begin
  if (WriteReg) begin registers[RegDest] <= WriteInput; end
  registers[R_Bits][CarryOutBit] <= CarryOutValue;
end
endmodule

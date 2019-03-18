//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
module ALU(
  input [7:0]        InputA,
                     InputB,
  input [3:0]        AluOp,
  input              CarryIn, WriteBranchDir,
  input [1:0]        ComparisonType,
  output logic [7:0] AluOut,     // or:  output reg [7:0] OUT
  output logic       CarryOut   // shift out/carry out
);

  always_comb begin
  {AluOut, CarryOut} = 0; // default -- clear carry out, zeroflag, branch, and output
  // single instruction for both LSW & MSW
  case(AluOp)
    ALU_ADD : {CarryOut, AluOut} = {1'b0,InputA} + InputB + CarryIn;  // add w/ carry in and out
    ALU_SHL: {CarryOut, AluOut} = {InputA, CarryIn}; // shift left w/ carry in and out
    ALU_SHR: {AluOut, CarryOut} = {CarryIn, InputA}; // shift right w/ carry in and out
    ALU_SUB : begin
      // AluOut = InputA + (~InputB) + 1 - CarryIn;
      AluOut = InputA - InputB - CarryIn;
			CarryOut = 0; // dont let it affect carry out
    end
    ALU_INC: AluOut = InputA + 1;
    ALU_DEC: AluOut = InputA - 1;
    ALU_MMM: begin //position of most significant 1
      if (InputA[7] == 1) AluOut = 3'b111;
      else if (InputA[6] == 1) AluOut = 3'b110;
      else if (InputA[5] == 1) AluOut = 3'b101;
      else if (InputA[4] == 1) AluOut = 3'b100;
      else if (InputA[3] == 1) AluOut = 3'b011;
      else if (InputA[2] == 1) AluOut = 3'b010;
      else if (InputA[1] == 1) AluOut = 3'b001;
      else AluOut = 3'b000;
    end
    ALU_LLL: begin // position of least significant 1
      if (InputA[0] == 1) AluOut = 3'b000;
      else if (InputA[1] == 1) AluOut = 3'b001;
      else if (InputA[2] == 1) AluOut = 3'b010;
      else if (InputA[3] == 1) AluOut = 3'b011;
      else if (InputA[4] == 1) AluOut = 3'b100;
      else if (InputA[5] == 1) AluOut = 3'b101;
      else if (InputA[6] == 1) AluOut = 3'b110;
      else AluOut = 3'b111;
    end
    ALU_CCC: begin // replace carry in bit with carry out bit
      AluOut = InputA;
      AluOut[CarryIn] = InputA[CarryOut];
    end
    ALU_SET: begin // replace nth bit with 1, where n = InputB % 8
      AluOut = InputA;
      AluOut[InputB[2:0]] = 1;
    end
    ALU_BRANCH: begin
      case(ComparisonType)
        CMP_EQ: AluOut = InputA == InputB; // TODO double chceeck this outputs 1
        CMP_NE: AluOut = InputA != InputB;
        CMP_GT: AluOut = InputA > InputB;
        CMP_LT: AluOut = InputA < InputB;
        default: AluOut = 0;
      endcase
    end
    ALU_SBD: begin
      AluOut = InputA;
      AluOut[3] = WriteBranchDir;
    //TODO: bitwise or?
    end

    default: {CarryOut, AluOut} = 0; // noop, zero out
  endcase


  $display("---ALU---");
  $display("Alu Op: %b", AluOp);
  $display("InputA: %b", InputA);
  $display("InputB: %b", InputB);
  $display("Alu Output: %b", AluOut);
  $display("CarryOut: %b", CarryOut);
  $display("---------");

  end

endmodule

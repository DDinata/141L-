//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
module ALU(
  input [7:0]        InputA,
                     InputB,
  input [3:0]        AluOp,
  input              CarryIn,
  input [1:0]        ComparisonType,
  output logic [7:0] AluOut,     // or:  output reg [7:0] OUT
  output logic       CarryOut   // shift out/carry out
);

  always_comb begin
    {AluOut, CarryOut} = 0;
    case(AluOp)
      ALU_ADD : {CarryOut, AluOut} = {1'b0,InputA} + InputB + CarryIn;

      ALU_SHL: {CarryOut, AluOut} = {InputA, CarryIn};

      ALU_SHR: {AluOut, CarryOut} = {CarryIn, InputA};

      ALU_SUB : begin
        AluOut = InputA - InputB - CarryIn;
  			CarryOut = (InputB > InputA);
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
        AluOut = {InputA[7:2], InputA[0], InputA[0]};
      end

      ALU_SET: begin // replace nth bit with 1, where n = InputB % 8
        AluOut = InputA;
        AluOut[InputB[2:0]] = 1;
      end

      ALU_BRANCH: begin
        case(ComparisonType)
          CMP_EQ: AluOut = InputA == InputB;
          CMP_NE: AluOut = InputA != InputB;
          CMP_GT: AluOut = InputA > InputB;
          CMP_LT: AluOut = InputA < InputB;
          default: AluOut = 0;
        endcase
        // $display("ALU Branch comparison: %1b", AluOut[0]);
      end

      //TODO: bitwise or?

      ALU_NOP: {CarryOut, AluOut} = 0;
      default: {CarryOut, AluOut} = 0;
    endcase


    if (AluOp != ALU_NOP) begin
      // // $write("----------ALU ");
      // $write("ALU ");
      // case(AluOp)
  		// 	ALU_ADD: $write("add");
  		// 	ALU_SUB: $write("sub");
  		// 	ALU_SHL: $write("shl");
  		// 	ALU_SHR: $write("shr");
  		// 	ALU_INC: $write("inc");
  		// 	ALU_DEC: $write("dec");
  		// 	ALU_MMM: $write("mmm");
  		// 	ALU_LLL: $write("lll");
  		// 	ALU_CCC: $write("ccc");
  		// 	ALU_SET: $write("set");
  		// 	ALU_BRANCH: $write("branch");
      // endcase
      // // $display("---------");
      // $display("");
      // $display("InputA: %d (%b)", InputA, InputA);
      // $display("InputB: %d (%b)", InputB, InputB);
      // $display("Output: %d (%b)", AluOut, AluOut);
      // $display("CarryIn: %d", CarryIn);
      // $display("CarryOut: %d", CarryOut);
      // //$display("-------------------------");
    end

  end

endmodule

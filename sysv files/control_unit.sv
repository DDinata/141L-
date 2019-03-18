import definitions::*;

module control_unit(

	input [8:0] Instruction,

	output logic ReadMem, // mem -> reg
	output logic WriteMem,  // reg -> mem

	output logic [3:0] RegSrc1, RegSrc2, RegDest,
	output logic WriteReg, // write enable RegDest
	output logic ReadReg, // reg -> reg

	output logic [3:0] AluOp,
	output logic UseCarryIn,

	output logic [7:0] ImmValue,
	output logic WriteImm, // write imm to R_A (for ACC)
	output logic AluImm, // use imm as second input to ALU (for BCC)

	output logic BranchEnable,
	output logic [1:0] ComparisonType,
	output logic WriteBranchDir
	);


	wire [4:0] OpCode = Instruction[8:4];  // first 5 bits opcode
	wire [3:0] Lower4 = Instruction[3:0];  // lower 4 bits of instruction

	always_comb begin

		// default values
		ImmValue = OpCode == BCC ? {Lower4, 4'b0000} : {4'b0000, Lower4};
		{ReadMem, WriteMem, WriteReg, WriteImm, BranchEnable, ReadReg, WriteBranchDir, AluImm} = 0;
		{RegSrc1, RegDest} = Lower4;
		RegSrc2 = R_Acc;
		AluOp = ALU_NOP;
		UseCarryIn = 0;
		ComparisonType = 2'b00;


		$display("Processing machine code: %b", OpCode);

		case(OpCode)
			LD:	begin
				ReadMem = 1;
				WriteReg = 1;
			end

			ST:	begin
				WriteMem = 1;
			end

			ACC:	begin
				RegDest = R_Acc;
				WriteReg = 1;
				WriteImm = 1;
			end

			BCC: begin
				RegSrc1 = R_Acc;
				RegDest = R_Acc;
				WriteReg = 1;
				AluImm = 1;
				AluOp = ALU_ADD;
			end

			MOV, GET: begin
				// mov = Lower4 -> R_Acc
				// get = R_Acc -> Lower4
				RegSrc1 = (OpCode == GET) ? R_Acc : Lower4;
				RegDest = (OpCode == GET) ? Lower4 : R_Acc;
				WriteReg = 1;
				ReadReg = 1;
			end

			ADD, SUB, SHL, SHR, INC, DEC, MMM, LLL: begin
				WriteReg = 1;
				UseCarryIn = OpCode == ADDC || OpCode == SUBC || OpCode == SHLC || OpCode == SHRC;
				if (OpCode == ADD || OpCode == ADDC) AluOp = ALU_ADD;
				if (OpCode == SUB || OpCode == SUBC) AluOp = ALU_SUB;
				if (OpCode == SHL || OpCode == SHLC) AluOp = ALU_SHL;
				if (OpCode == SHR || OpCode == SHRC) AluOp = ALU_SHR;
				if (OpCode == INC) AluOp = ALU_INC;
				if (OpCode == DEC) AluOp = ALU_DEC;
				if (OpCode == MMM) AluOp = ALU_MMM;
				if (OpCode == LLL) AluOp = ALU_LLL;
			end

			CCC: begin
				WriteReg = 1;
				RegSrc1 = R_Bits;
				RegDest = R_Bits;
				AluOp = ALU_CCC;
			end

			SET: begin
				WriteReg = 1;
				AluOp = ALU_SET;
			end

			BEZ, BNZ, BEQ, BNE, BGT, BLT: begin
				BranchEnable = 1;
				if (OpCode == BEZ || OpCode == BNZ)
					RegSrc2 = R_Zero;
				else
					RegSrc2 = R_BranchComparison;
				case (OpCode)
					BEZ, BEQ: ComparisonType = CMP_EQ;
					BNZ, BNE: ComparisonType = CMP_NE;
					BGT: ComparisonType = CMP_GT;
					BLT: ComparisonType = CMP_LT;
					default: ComparisonType = CMP_EQ;
				endcase
			end

			SBD: begin
				WriteReg = 1;
				RegSrc1 = R_Bits;
				RegDest = R_Bits;
				WriteBranchDir = 1;
				AluOp = ALU_SBD;
			end

			default: begin
				$display("Invalid machine code: %b", OpCode);
			end
		endcase
	end



endmodule

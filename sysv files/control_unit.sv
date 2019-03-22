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
	output logic [1:0] ComparisonType
);

	wire [4:0] OpCode = Instruction[8:4];  // first 5 bits opcode
	wire [3:0] Lower4 = Instruction[3:0];  // lower 4 bits of instruction

	always_comb begin

		ImmValue = OpCode == BCC ? {Lower4, 4'b0000} : {4'b0000, Lower4};
		UseCarryIn = OpCode == ADDC || OpCode == SUBC || OpCode == SHLC || OpCode == SHRC;
		WriteReg = OpCode != BEZ && OpCode != BNZ && OpCode != BEQ && OpCode != BNE &&
							 OpCode != BGT && OpCode != BLT && OpCode != ST;
	  BranchEnable = OpCode == BEZ || OpCode == BNZ || OpCode == BEQ || OpCode == BNE ||
							 OpCode == BGT || OpCode == BLT;
		WriteImm = OpCode == ACC;
		AluImm = OpCode == BCC;
		ReadMem = OpCode == LD;
		WriteMem = OpCode == ST;
		ReadReg = OpCode == MOV || OpCode == GET;

		// defaults
		{RegSrc1, RegSrc2, RegDest} = R_Accumulator;
		AluOp = ALU_NOP;
		ComparisonType = CMP_EQ;

		case(OpCode)
			LD, ST:	begin
				RegSrc1 = Lower4;
				RegSrc2 = R_Accumulator;
				RegDest = Lower4;
				AluOp = ALU_NOP;
			end

			ACC:	begin
				RegSrc1 = R_Zero;
				RegSrc2 = R_Zero;
				RegDest = R_Accumulator;
				AluOp = ALU_NOP;
			end

			BCC: begin
				RegSrc1 = R_Accumulator;
				RegSrc2 = R_Zero;
				RegDest = R_Accumulator;
				AluOp = ALU_ADD;
			end

			MOV, GET: begin
				RegSrc1 = (OpCode == MOV) ? R_Accumulator : Lower4;
				RegSrc2 = R_Zero;
				RegDest = (OpCode == MOV) ? Lower4 : R_Accumulator;
				AluOp = ALU_NOP;
			end

			ADD, SUB, ADDC, SUBC: begin
				RegSrc1 = Lower4;
				RegSrc2 = R_Accumulator;
				RegDest = Lower4;
				if (OpCode == ADD || OpCode == ADDC) AluOp = ALU_ADD;
				if (OpCode == SUB || OpCode == SUBC) AluOp = ALU_SUB;
			end

			SHL, SHR, SHLC, SHRC, INC, DEC: begin
				RegSrc1 = Lower4;
				RegSrc2 = R_Zero;
				RegDest = Lower4;
				if (OpCode == SHL || OpCode == SHLC) AluOp = ALU_SHL;
				if (OpCode == SHR || OpCode == SHRC) AluOp = ALU_SHR;
				if (OpCode == INC) AluOp = ALU_INC;
				if (OpCode == DEC) AluOp = ALU_DEC;
			end

			MMM, LLL: begin
				RegSrc1 = Lower4;
				RegSrc2 = R_Zero;
				RegDest = R_Accumulator;
				if (OpCode == MMM) AluOp = ALU_MMM;
				if (OpCode == LLL) AluOp = ALU_LLL;
			end

			CCC: begin
				RegSrc1 = R_Bits;
				RegSrc2 = R_Zero;
				RegDest = R_Bits;
				AluOp = ALU_CCC;
			end

			SET: begin
				RegSrc1 = Lower4;
				RegSrc2 = R_Accumulator;
				RegDest = Lower4;
				AluOp = ALU_SET;
			end

			BEZ, BNZ, BEQ, BNE, BGT, BLT: begin
				RegSrc1 = Lower4;
				RegSrc2 = OpCode == BEZ || OpCode == BNZ ? R_Zero : R_BranchComparison;
				RegDest = R_Zero;
				AluOp = ALU_BRANCH;
				case (OpCode)
					BEZ, BEQ: ComparisonType = CMP_EQ;
					BNZ, BNE: ComparisonType = CMP_NE;
					BGT: ComparisonType = CMP_GT;
					BLT: ComparisonType = CMP_LT;
					default: ComparisonType = CMP_EQ;
				endcase
			end

			// default: $display("INVALID MACHINE CODE: %b", OpCode);
		endcase

		// $display("Processing machine code: %b", Instruction);
		// $write("INSTRUCTION: ");
		// case(OpCode)
		// 	LD:	$write("ld");
		// 	ST:	$write("st");
		// 	ACC: $write("acc");
		// 	BCC: $write("bcc");
		// 	MOV: $write("mov");
		// 	GET: $write("get");
		// 	ADD: $write("add");
		// 	ADDC: $write("addc");
		// 	SUB: $write("sub");
		// 	SUBC: $write("subc");
		// 	SHL: $write("shl");
		// 	SHLC: $write("shlc");
		// 	SHR: $write("shr");
		// 	SHRC: $write("shrc");
		// 	INC: $write("inc");
		// 	DEC: $write("dec");
		// 	MMM: $write("mmm");
		// 	LLL: $write("lll");
		// 	CCC: $write("ccc");
		// 	SET: $write("set");
		// 	BEZ: $write("bez");
		// 	BNZ: $write("bnz");
		// 	BEQ: $write("beq");
		// 	BNE: $write("bne");
		// 	BGT: $write("bgt");
		// 	BLT: $write("blt");
		// 	default: $write("invalid");
		// endcase
		// $display(" %3d", Lower4);

	end



endmodule

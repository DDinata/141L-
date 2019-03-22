// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel
// CSE141L
// partial only
module TopLevel(		   // you will have the same 3 ports
    input     start,	   // init/reset, active high
    input     CLK,		   // clock -- posedge used inside design
    output    halt		   // done flag from DUT
    );

wire  [9:0] PC;            // program count
wire  [8:0] Instruction;   // our 9-bit opcode

wire  [3:0] RegSrc1, RegSrc2, RegDest;
wire  [7:0] RegOut1, RegOut2, RegWriteValue;
wire        WriteReg,	   // reg_file write enable
            ReadReg,
            WriteImm;
wire  [7:0] ImmValue;

wire  [7:0] AluIn1, AluIn2, AluOut;
wire  [3:0] AluOp;
wire  [1:0] ComparisonType;
wire        AluImm;       // chose between ImmValue and RegSrc2

wire  [7:0] MemWriteValue,   // memory file input for st
            MemAddr,         // memory location to ld/st
            MemOut;          // memory file output for ld
wire        ReadMem,         // data_memory read enable
            WriteMem;        // data_memory write enable

wire        CarryOut,        // carry output from ALU
            CarryIn,         // carry input to ALU = CarryInValue & UseCarryIn
            CarryInValue,    // value current in R_CarryIn
            UseCarryIn;      // whether we should select CarryIn

wire        BranchEnable,    // whether we should select comparison result
            BranchTaken,     // comparison result
            BranchDirection; // direction if branch taken - R_Acc[0]
wire  [7:0] BranchAmount;    // register for jump amount

logic[15:0] cycle_ct;	   // standalone; NOT PC!

  // Program Counter
  assign BranchTaken = AluOut[0];
  PC PC1 (
	.init(start),
	.halt,
  .BranchEnable,
  .BranchTaken,
  .JumpDirection(BranchDirection),
  .JumpAmount(BranchAmount),
	.CLK,
	.PC
	);

  // Control decoder
  control_unit ctr1 (
	.Instruction,
  .ReadMem,
	.WriteMem,
  .ReadReg,
	.RegSrc1,
	.RegSrc2,
	.RegDest,
	.WriteReg,
	.AluOp,
  .ComparisonType,
  .UseCarryIn,
  .AluImm,
	.ImmValue,
	.WriteImm,
	.BranchEnable
  );

  // instruction ROM
  InstROM instr_ROM1(
	.InstAddress   (PC),
	.InstOut       (Instruction)
	);

  // mux for RegWriteValue input
  // assign begin
  //   if (ReadMem) RegWriteValue = MemOut;
  //   else if (WriteImm) RegWriteValue = ImmValue;
  //   else if (ReadReg) RegWriteValue = RegOut1;
  //   else if (WriteBranchDir) begin
  //     RegWriteValue = RegOut1;
  //     RegWriteValue[3] = ImmValue[0];
  //   end
  //   else RegWriteValue = AluOut;
  // end


  // reg file
  assign RegWriteValue = ReadMem ? MemOut :    // LD
                         WriteImm ? ImmValue:  // ACC
                         ReadReg ? RegOut1 :   // MOV, GET
                                   AluOut;     // ALU operation
	reg_file reg_file1 (
		.CLK,
    .init(start),
		.RegSrc1,
		.RegSrc2,
		.RegDest,
		.WriteReg,
		.WriteInput (RegWriteValue) ,
		.Out1 (RegOut1),
		.Out2 (RegOut2),
    .CarryOutValue (CarryOut),
    .CarryInValue,
    .BranchDirection,
    .BranchAmount
	);

  assign AluIn1 = RegOut1;						          // connect RF out to ALU in
	assign AluIn2 = AluImm ? ImmValue : RegOut2;
  assign CarryIn = UseCarryIn & CarryInValue;
  ALU ALU1  (
	  .AluOp,
	  .InputA (AluIn1),
	  .InputB (AluIn2),
	  .CarryIn,
	  .AluOut,
	  .CarryOut,
	  .ComparisonType
	);

  assign MemWriteValue = RegOut1; // regout1 is always data
  assign MemAddr = RegOut2; // regout2 is always mem location
	data_mem data_mem1(
		.DataAddress  (MemAddr),
		.ReadMem,
		.WriteMem,
		.DataIn (MemWriteValue),
		.DataOut (MemOut),
		.CLK,
		.reset (start)
	);

// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

endmodule

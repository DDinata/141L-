package definitions;

// 0 thru 7 - ALU operations
const logic [4:0] ADD   = 5'b00000;
const logic [4:0] ADDC  = 5'b00001;
const logic [4:0] SUB   = 5'b00010;
const logic [4:0] SUBC  = 5'b00011;
const logic [4:0] SHL   = 5'b00100;
const logic [4:0] SHLC  = 5'b00101;
const logic [4:0] SHR   = 5'b00110;
const logic [4:0] SHRC  = 5'b00111;

// 8 thru 13 - helper ops
const logic [4:0] INC   = 5'b01000;
const logic [4:0] DEC   = 5'b01001;
const logic [4:0] MMM   = 5'b01010;
const logic [4:0] LLL   = 5'b01011;
const logic [4:0] CCC   = 5'b01100;
const logic [4:0] SET   = 5'b01101;

//  16 thru 24 - branching
const logic [4:0] BEZ   = 5'b10000;
const logic [4:0] BNZ   = 5'b10001;
const logic [4:0] BEQ   = 5'b10010;
const logic [4:0] BNE   = 5'b10011;
const logic [4:0] BGT   = 5'b10100;
const logic [4:0] BLT   = 5'b10101;
const logic [4:0] SBD   = 5'b10110;

// 26 thru 31, movement and imms
const logic [4:0] LD    = 5'b11000;
const logic [4:0] ST    = 5'b11001;
const logic [4:0] MOV   = 5'b11100;
const logic [4:0] GET   = 5'b11101;
const logic [4:0] ACC   = 5'b11110;
const logic [4:0] BCC   = 5'b11111;

// ALU microcode
const logic [3:0] ALU_NOP   = 4'b0000;
const logic [3:0] ALU_ADD   = 4'b0001;
const logic [3:0] ALU_SUB   = 4'b0010;
const logic [3:0] ALU_SHL   = 4'b0011;
const logic [3:0] ALU_SHR   = 4'b0100;
const logic [3:0] ALU_aaa   = 4'b0101;
const logic [3:0] ALU_bbb   = 4'b0110;
const logic [3:0] ALU_ccc   = 4'b0111;
const logic [3:0] ALU_INC   = 4'b1000;
const logic [3:0] ALU_DEC   = 4'b1001;
const logic [3:0] ALU_MMM   = 4'b1010;
const logic [3:0] ALU_LLL   = 4'b1011;
const logic [3:0] ALU_CCC   = 4'b1100;
const logic [3:0] ALU_BRANCH= 4'b1101;
const logic [3:0] ALU_SET   = 4'b1110;

// Comparison types
const logic [1:0] CMP_EQ = 2'b00;
const logic [1:0] CMP_NE = 2'b01;
const logic [1:0] CMP_GT = 2'b10;
const logic [1:0] CMP_LT = 2'b11;

// register shorthand
const logic [3:0] R_0  = 4'b0000;
const logic [3:0] R_1  = 4'b0001;
const logic [3:0] R_2  = 4'b0010;
const logic [3:0] R_3  = 4'b0011;
const logic [3:0] R_4  = 4'b0100;
const logic [3:0] R_5  = 4'b0101;
const logic [3:0] R_6  = 4'b0110;
const logic [3:0] R_7  = 4'b0111;
const logic [3:0] R_8  = 4'b1000;
const logic [3:0] R_9  = 4'b1001;
const logic [3:0] R_10 = 4'b1010;
const logic [3:0] R_11 = 4'b1011;
const logic [3:0] R_12 = 4'b1100;
const logic [3:0] R_13 = 4'b1101;
const logic [3:0] R_14 = 4'b1110;
const logic [3:0] R_15 = 4'b1111;

// named registers
const logic [3:0] R_Accumulator = R_15;
const logic [3:0] R_BranchComparison = R_14;
const logic [3:0] R_BranchTarget = R_13;
const logic [3:0] R_Bits = R_12;
const logic [3:0] R_One = R_11;
const logic [3:0] R_Zero = R_10;

// bit positions in R_Bits
const int CarryOutBit = 0;
const int CarryInBit = 1;
const int BranchDirBit = 3;

endpackage

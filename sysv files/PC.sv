module PC(
  input init,
        CLK,
        BranchTaken,
        JumpDir,
  input [7:0] JumpAmount,

  output logic halt,
  output logic [9:0] PC = 0
);

  always @(posedge CLK) begin
    if(!init) begin
      $display("PC: %d", PC);
      if (BranchTaken)
        if (JumpDir)
      	  PC <= PC + JumpAmount;
        else
          PC <= PC - JumpAmount;
      else
        PC <= PC + 1;

      if (PC == 7)
        halt <= 1;
    end
  end

endmodule

module PC(
  input init,
        CLK,
        BranchEnable,
        BranchTaken,
        JumpDirection,
  input [7:0] JumpAmount,

  output logic halt,
  output logic [9:0] PC = 0
);

logic paused;

  always @(posedge CLK) begin
    if (init) begin
      halt <= 0;
      $display("STARTING");
    end

    if(!init && !halt) begin
      //$display("----------------------------------------------PC: %3d", PC);
      // $display("PC %3d -> %3d", PC-1, PC);
      if (BranchEnable) begin
        if (BranchTaken) begin
          if (JumpDirection) PC <= PC + JumpAmount;
          else PC <= PC - JumpAmount;
          // $display("Branch taken");
          // $display("Direction: %1d Amount: %4d", JumpDirection, JumpAmount);
        end
        else begin
          // $display("Branch not taken");
          PC <= PC + 1;
        end
      end
      else PC <= PC + 1;

      if (PC == 168) begin
        PC <= PC + 1;
        halt <= 1;
        $display("HALTING");
      end
      if (PC == 365) begin
        PC <= PC + 1;
        halt <= 1;
        $display("HALTING");
      end
      if (PC == 590) begin
        PC <= PC + 1;
        halt <= 1;
        $display("HALTING");
        halt <= 1;
      end
    end
  end

endmodule

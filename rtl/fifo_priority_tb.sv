module fifo_priority_tb;

logic rst = 0;
logic clk = 0;

always begin
  #5 clk = ~clk;
end

parameter int DW    = 33;
parameter int DEPTH = 5;

// input channel
logic[DW-1:0]  data_in   = 0;
logic          vld_i  = 0;
logic          rdy_o = 0;

// output channel
logic[DW-1:0]  data_out  = 0;
logic          vld_o = 0;
logic          rdy_i  = 0;

fifo_priority #(
  .DW    (DW),
  .DEPTH (DEPTH)
) DUT (.*);

initial begin
  RESET();

  // Run 10 times
  repeat(10) begin
    //sample from 0 to 5
    repeat($urandom_range(5)) WRITE();
    //sample from 0 to 5
    repeat($urandom_range(5)) READ();
  end

  $stop;
end

task RESET;
  rst <= 1;
  repeat(3) @(posedge clk);
  rst <= 0;
  repeat(3) @(posedge clk);
  $display("[INFO]: Done RESET...");
endtask

// Add automatic to make the `task`
// behave like a C-function
task automatic WRITE();
  // $urandom_range(max, min=0) selects randomly
  // between min and max. Here between 2 and 4
  int unsigned n = $urandom_range(4, 2);
  repeat(n) @(posedge clk);
  
  // $urandom(seed) is a random number generator.
  // Change seed value to generate a different 
  // sequence of random numbers.
  data_in  <= {$urandom_range(1,0),$urandom};
  vld_i <= $urandom_range(1,0);
  @(posedge clk);
  $display("@ %t\t[WRITER] --> vld_i:%1b, data_in:%9h", $time, vld_i, data_in);

  if (vld_i) begin
    if(rdy_o) begin
      $display("@ %t\t[WRITER] --> written [%9h] with priority: %1b", $time, data_in, data_in[DW-1]);
    end else begin
      $display("@ %t\t[WRITER] --> denied [%9h]", $time, data_in);
    end
    vld_i <= 1'b0;
  end else begin
    $display("@ %t\t[WRITER] --> idle", $time);
  end
  @(posedge clk);

endtask

task automatic READ();

  int unsigned n = $urandom_range(4, 2);
  repeat(n) @(posedge clk);

  rdy_i <= $urandom_range(1,0);
  @(posedge clk);
  $display("@ %t\t[READER] --> rdy_i:%1b", $time, rdy_i);

  if (rdy_i) begin
    if (vld_o) begin
      $display("@ %t\t[READER] --> read [%9h] from priority: %1b ", $time, data_out, data_out[DW-1]);
    end else begin
      $display("@ %t\t[READER] --> ignored non-valid data [%9h]", $time, data_out);
    end
    rdy_i <= 1'b0;
  end else begin
    $display("@ %t\t[READER] --> idle", $time);
  end
  @(posedge clk);

endtask

endmodule
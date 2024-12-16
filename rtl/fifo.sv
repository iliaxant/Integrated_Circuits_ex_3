module fifo
#(
  parameter int N = 4, // Number of elements
  parameter int M = 16 // Element bit-width
)(
  input  logic         clk,
  input  logic         rst,

  // input channel
  input  logic [M-1:0] din,
  input  logic         write,
  output logic         full,
  
  // output channel
  output logic [M-1:0] dout,
  output logic         empty,
  input  logic         read
);

// We want to keep it private
// so we use `localparam`.
// This is a constant value.
localparam W = $clog2(N);

// Internal state
logic[N-1:0][M-1:0] mem;
logic[W-1:0]        head, tail;
logic[W:0]          items;

// merge control signalsl
logic[1:0] cmd;

assign cmd = {write, read}; 

always_ff @(posedge clk) begin
  if (rst) begin
    head  <= 'd0;
    tail  <= 'd0;
    items <= 'd0;
    mem   <= 'd0;
  end else begin
    case (cmd)
      2'b00: begin 
        // nothing to do
      end
      
      2'b01: begin
        if (!empty) begin // read
          head  <= head  + 'd1;
          items <= items - 'd1;
        end
      end

      2'b10: begin
        if (!full) begin // write
          mem[tail] <= din;
          tail      <= tail  + 'd1;
          items     <= items + 'd1;
        end
      end

      2'b11: begin // both read and write
        if (!full) begin
          mem[tail] <= din;
          tail      <= tail + 'd1;
        end
        
        if (!empty) begin
          head <= head + 'd1;
        end
      end

      default: begin
        head  <= 'd0;
        tail  <= 'd0;
        items <= 'd0;
      end
    endcase

    // Return to zero 
    // if N and M are not a power of 2
    if (head == (N)) head <= 'd0;
    if (tail == (N)) tail <= 'd0;
  end
end

// combinational reads
assign dout = mem[head]; 

// Output signals
assign full = (items == N); 
assign empty = (items == 0);

endmodule

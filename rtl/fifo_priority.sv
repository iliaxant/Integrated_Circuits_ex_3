module fifo_priority
#(
  parameter int DW    = 33,
  parameter int DEPTH = 5
)
(
  input  logic                clk,
  input  logic                rst,

  // input channel
  input  logic[DW-1:0]      data_in,
  input  logic              vld_i,
  output logic              rdy_o,

  // output channel
  output logic[DW-1:0]   data_out,
  output logic              vld_o,
  input  logic              rdy_i
);

logic hp_data, hp_data_out;
logic np_data, np_data_out;

logic hp_full, hp_empty;
logic np_full, np_empty;

logic hp_push, hp_pop;
logic np_push, np_pop;

assign hp_data = data_in;
assign np_data = data_in;

assign hp_push = vld_i & !hp_full & !np_full & data_in[DW-1];
assign np_push = vld_i & !hp_full & !np_full & !data_in[DW-1];

assign hp_pop = rdy_i & !hp_empty;
assign np_pop = rdy_i & !np_empty & hp_empty;

assign data_out = hp_empty ? np_data_out : hp_data_out;

fifo #(
  .N (DEPTH),
  .M (DW)
)
fifo_hp (
  .*,

  // input channel
  .din   (hp_data),
  .write (hp_push),
  .full  (hp_full),

  // output channel
  .dout  (hp_data_out),
  .empty (hp_empty),
  .read  (hp_pop)
);

fifo #(
  .N (DEPTH),
  .M (DW)
)
fifo_np (
  .*,

  // input channel
  .din   (np_data),
  .write (np_push),
  .full  (np_full),

  // output channel
  .dout  (np_data_out),
  .empty (np_empty),
  .read  (np_pop)
);

assign rdy_o = !(hp_full | np_full);
assign vld_o = (!hp_empty) | (!np_empty);

endmodule
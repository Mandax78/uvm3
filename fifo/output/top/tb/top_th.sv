module top_th;

  timeunit      1ns;
  timeprecision 1ps;


  logic clk = 0;
  logic rstn;

  always #10 clk = ~clk;

  initial
  begin
    rstn = 0;
    #75 rstn = 1;
  end

  fifo_in_if fifo_in_if();
  fifo_out_if fifo_out_if();

  assign fifo_in_if.clk = clk;
  assign fifo_out_if.clk = clk;

  fifo fifo(
    .clk (clk),
    //.rstn (rstn),
    .data_in (fifo_in_if.data_in),
    .data_in_vld (fifo_in_if.data_in_vld),
    .data_in_rdy (fifo_in_if.data_in_rdy),
    .data_out (fifo_out_if.data_out),
    .data_out_vld (fifo_out_if.data_out_vld),
    .data_out_rdy (fifo_out_if.data_out_rdy)
  );

    assert property (@(posedge clk)  (fifo_in_if.data_in_rdy == 0)); // full
    assert property (@(posedge clk)  (fifo_out_if.data_out_vld == 0)); // empty

  sequence full;
    @(posedge clk)  (fifo_in_if.data_in_rdy == 0); // full
  endsequence: full

  sequence empty;
    @(posedge clk)  (fifo_out_if.data_out_vld == 0); // empty
  endsequence: empty

  property full_empty_full;
    full ##[1:$] empty ##[1:$] full;
  endproperty: full_empty_full

  cover property(full_empty_full);
// coveprety(sequence)

// ##[1:$] : ##[1:$]
endmodule

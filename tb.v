module tb_top;
    // Define testbench ports
    reg clk = 0;
    reg rstn;
    reg wr;
    reg s_wait = 0;
    reg newd;
    reg [31:0] ain;
  
    reg [7:0] din;
    wire [7:0] dout;
    reg [1:0] delay = 0;
    reg corrupt_penable;
    
    wire pslverr;

always #10 clk = ~clk;
    // Instantiate the top module
    top dut (
        .clk(clk),
        .rstn(rstn),
        .wr(wr),
        .newd(newd),
        .ain(ain),
        .din(din),
        .dout(dout),
        .s_wait(s_wait),
      .err(pslverr),
      .corrupt_penable(corrupt_penable)
    );
    
    initial 
    begin
    rstn = 1'b0;
    repeat(5) @(posedge clk);
    rstn = 1'b1;
    corrupt_penable = 1'b0;
    
        for (int i = 0; i< 5; i++)
        begin
          newd = 1;
          s_wait = 1;
          wr = 1;
          ain = i;
          din = $urandom_range(100,250);
          delay = $urandom_range(0,3);
          repeat(delay)@(posedge clk);
          s_wait = 0;
          @(posedge clk);
          @(negedge dut.m1.pready);
          @(posedge clk);
        end
        
        
        for (int i = 0; i< 5; i++)
        begin
          newd = 1;
          s_wait = 1;
          wr = 0;
          ain = i;
          din = $urandom_range(100,250);
          delay = $urandom_range(0,3);
          repeat(delay)@(posedge clk);
          s_wait = 0;
          @(posedge clk);
          @(negedge dut.m1.pready);
          @(posedge clk);
        end       
      
      
      /// invalid address range during write
              
      for(int i = 0; i < 1; i++)
        begin
          @(posedge clk);
          newd = 1;
          ain = $urandom_range(16,255);
          wr = 1;
          din = $urandom;
          @(negedge dut.m1.pready);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
        end     
      
      ///  corrupting penable.
      
          @(posedge clk);
          corrupt_penable = 1;
          newd = 1;
          ain = 32'd10;
          wr = 1;
          din = 8'd111;
          @(negedge pslverr);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
      
    //#1000;  
    $stop;
    end
  
    initial
      begin
        $dumpfile("dump.vcd");
        $dumpvars;
      end
  

endmodule  

module top(
input clk,rstn,wr,newd,s_wait,
input [31:0] ain,
input [7:0] din,
input corrupt_penable,
output [7:0] dout,
output err
);

wire psel, penable, pready, pwrite;
wire [7:0] prdata, pwdata;
wire [31:0] paddr;
 

   apb_master m1 (
        .pclk(clk),
        .presetn(rstn),
        .addrin(ain),
        .datain(din),
        .wr(wr),
        .newd(newd),
        .prdata(prdata),
        .pready(pready),
        .psel(psel),
        .penable(penable),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .dataout(dout)
    );



    apb_slave s1 (
        .pclk(clk),
        .presetn(rstn),
        .paddr(paddr),
        .psel(psel),
        .penable(penable & ~corrupt_penable),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .prdata(prdata),
        .pready(pready),
        .slave_wait(s_wait),
        .pslverr(err)
    );
    
    

endmodule

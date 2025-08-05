module apb_master(pclk, presetn, addrin, datain, wr, newd, prdata, pready, psel, penable, paddr, pwdata, pwrite, dataout);
  
  input pclk, presetn, wr, newd, pready;
  input [31:0] addrin;
  input [7:0] datain, prdata;
  
  output reg psel, pwrite;
  output reg [31:0] paddr;
  output reg [7:0] pwdata;
  output [7:0] dataout;
  output penable;
  
  localparam [1:0] idle = 0, setup = 1, enable = 2;
  
  reg [1:0] pstate, nstate;
  
  always @(posedge pclk) begin
    if(presetn == 1'b0) 
      pstate <= idle;
    else
      pstate <= nstate;
  end
  
  always@(*) begin
    case(pstate)
      idle: begin
        if(newd == 1'b1) begin
          nstate = setup;
        end
        else begin
          nstate = idle;
        end
      end
      
      setup: begin
        nstate = enable;
      end
      
      enable: begin
        if(newd == 1'b1) begin
          if(pready == 1'b1) begin
            nstate = setup;
          end
          else begin
            nstate = enable;
          end
        end
        else begin
          nstate = idle;
        end
      end
      
      default: begin
        nstate = idle;
      end
            
    endcase
  end
  
  always @(posedge pclk, negedge presetn) begin
    if(presetn == 1'b0) begin
      psel <= 0;
    end
    else if( pstate == idle) begin
      psel <= 0;
    end
    else if( pstate == setup) begin
      psel <= 1;
    end
    else if( pstate == enable) begin
      psel <= 1;
    end
    else begin
      psel <= 0;
    end
  end
  
  // apb master output signal logic
  
  always @(posedge pclk) begin
    case(pstate) 
      idle: begin
        pwrite <= 0;
        pwdata <= 0;
        paddr <= 0;
      end
      
      setup: begin
        paddr <= addrin;
        pwrite <= wr;
        if(wr == 1'b1) begin
          pwdata <= datain;
        end
      end
      
    endcase
  end
  
  assign penable = (pstate == enable)?1'b1:1'b0;
    
  assign dataout = (pwrite == 0)?((pready == 1)? prdata:8'd0):8'd0;
  
endmodule

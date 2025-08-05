module apb_slave(pclk, presetn, paddr, psel, penable, pwdata, pwrite, prdata, pready, pslverr, slave_wait);
  
  input pclk, presetn, psel,penable, pwrite, slave_wait;
  input [31:0] paddr;
  input [7:0] pwdata;
  
  output reg [7:0] prdata;
  output reg pready;
  output pslverr;
  
  reg [7:0] mem[16];
  
  localparam [1:0] idle = 0, read = 1, write = 2;
  reg [1:0] pstate, nstate;
  reg data_validerr, addr_rangeerr, addr_validerr, cycle_twoerr;
  
  always @(posedge pclk) begin
    if(presetn == 1'b0) 
      pstate <= idle;
    else
      pstate <= nstate;
  end
  
  always@(*) begin
    case(pstate)
      idle: begin
        pready = 1'b0;
        prdata = 8'd0;
        cycle_twoerr = 1'b0;
        
        if(psel == 1) begin
          if(pwrite == 1) 
            nstate = write;
          else
            nstate = read;
        end
        
      end
      
      read: begin
        if(psel == 1 && penable == 1) begin
          if(slave_wait == 1) begin
            nstate = read;
          end
          else begin
            if(!data_validerr & !addr_rangeerr & !addr_validerr) begin
              prdata = mem[paddr];
              pready = 1;
              nstate = idle;
            end
            else begin
              prdata = 8'h00;
              pready = 1;
              nstate = idle;
            end
          end
        end
        else begin
          nstate = idle;
          cycle_twoerr = 1'b1;
        end
        
      end
      
      write: begin
        if(psel == 1 && penable == 1) begin
          if(slave_wait == 1) begin
            nstate = write;
          end
          else begin
            if(!data_validerr & !addr_rangeerr & !addr_validerr) begin
              mem[paddr] = pwdata;
              pready = 1;
              nstate = idle;
            end
            else begin
              nstate = idle;
              pready = 1;
            end
          end
        end
        else begin
          nstate = idle;
          cycle_twoerr = 1'b1;
        end
      end
      
      default: nstate = idle;
      
    endcase
    
  end
  
  
  always @(*) begin
    addr_rangeerr = (paddr>4'd15);
    if(paddr >= 0)
      addr_validerr = 0;
    else
      addr_validerr = 1;
  end
  
  always @(*) begin
    if(pwdata >= 0) 
      data_validerr = 0;
    else
      data_validerr = 1;
  end
  
  
  assign pslverr = (cycle_twoerr)?1'b1:(psel&penable&pready)?(addr_validerr|data_validerr|addr_rangeerr):0;
    
  
endmodule

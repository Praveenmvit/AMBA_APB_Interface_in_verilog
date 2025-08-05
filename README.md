# AMBA_APB_Interface_in_verilog
AMBA - Advanced Microcontroller Bus Architecture.  
APB - Advanced Peripheral Bus.  
edaplayground Link: https://www.edaplayground.com/x/kBWw

# Introduction
-> The APB protocol is a low-cost interface, optimized for minimal power consumption and reduced interface complexity.  
-> The APB interface is not pipelined and is a simple, synchronous protocol. Every transfer takes at least two cycles to complete.  
-> The APB interface is designed for accessing the programmable control registers of peripheral devices.  
-> APB peripherals are typically connected to the main memory system using an APB bridge.  
-> For example, a bridge from AXI to APB could be used to connect a number of APB peripherals to an AXI memory system.  
-> APB transfers are initiated by an APB bridge.  
-> APB bridges can also be referred to as a Requester.  
-> A peripheral interface responds to requests. APB peripherals can also be referred to as a Completer.  
<div align="center">
  <img width="706" height="455" alt="image" src="https://github.com/user-attachments/assets/4adb15e0-0adb-4db6-91ba-dc9bf5062c0b" />
</div>  

# Signal Description of few APB Signals
|**Paddr**  | -> | Width of the address bus is variable, upto 32 bits.  | 
|**Penable**| -> | Indicates second and subsequent cycle of APB transfer.  |
|**Pwrite** | -> | Indicates the write or read access, write - HIGH , read - LOW.  |
|**PWdata** | -> | The PWDATA write data bus is driven by the APB bridge Requester during write cycles when PWRITE is HIGH. PWDATA can be 8 bits, 16 bits, or 32 bits wide.  |
|**Prdata** | -> | The PRDATA read data bus is driven by the selected Completer during read cycles when PWRITE is LOW. PRDATA can be 8 bits, 16 bits, or 32 bits wide.  |

# Write Transfer
  There are two state of write transfer  
    1. no wait.  
    2. wait.  

## NO Wait write transfer
   Write transfer is done throught 3 states.  
   SETUP  -> The select signal PSEL is asserted and PADDR, PWRITE signals are assigned with proper valid address and data values.  
   ACCESS -> PENABLE is asserted. PREADY is asserted by the Completer at the rising edge of PCLK to indicate that the write data will be accepted. PADDR, PWDATA, and any other control signals, must be stable until the transfer completes.  
   END OF TRANSFER -> PENABLE is deasserted. PSEL is also deasserted, unless there is another transfer to the same peripheral.  

<div align="center">
  <img width="470" height="335" alt="image" src="https://github.com/user-attachments/assets/6dbb7866-0260-4738-a1ed-0056cf03e79b" />
</div>  



    


  

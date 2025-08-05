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
| **Signal**   | **Description** |
|--------------|------------------|
| **PADDR**    | Width of the address bus is variable, up to 32 bits. |
| **PENABLE**  | Indicates the second and subsequent cycles of the APB transfer. |
| **PWRITE**   | Indicates the type of access: **HIGH** for write, **LOW** for read. |
| **PWDATA**   | Write data bus. Driven by the APB bridge (Requester) during write cycles when `PWRITE` is HIGH. Width can be 8, 16, or 32 bits. |
| **PRDATA**   | Read data bus. Driven by the selected Completer during read cycles when `PWRITE` is LOW. Width can be 8, 16, or 32 bits. |

# Write Transfer
  There are two state of write transfer  
    1. no wait.  
    2. wait.  

## NO Wait write transfer
   Write transfer is done throught 3 states.  
| Phase             | Description |
|------------------|-------------|
| **SETUP**         | The select signal `PSEL` is asserted and `PADDR`, `PWRITE` signals are assigned with valid address and data values. |
| **ACCESS**        | `PENABLE` is asserted. `PREADY` is asserted by the Completer at the rising edge of `PCLK` to indicate that the write data will be accepted. `PADDR`, `PWDATA`, and any control signals must remain stable until the transfer completes. |
| **END OF TRANSFER** | `PENABLE` is deasserted. `PSEL` is also deasserted, unless there is another transfer to the same peripheral. |

<div align="center">
  <img width="470" height="335" alt="image" src="https://github.com/user-attachments/assets/6dbb7866-0260-4738-a1ed-0056cf03e79b" />
</div>  



    


  

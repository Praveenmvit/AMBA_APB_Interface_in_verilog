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

  

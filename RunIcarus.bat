cd\
cd C:\Users\drumi\OneDrive\Documents\GitHub\COA_Project_G6
del Wavedump.vcd



C:\iverilog\bin\iverilog -g2012 -Wall -o RISC_Processor.vvp RISC_Processor.v RISC_Processor_tb.v
PAUSE
C:\iverilog\bin\vvp RISC_Processor.vvp
dir
PAUSE
C:\iverilog\gtkwave\bin\gtkwave -f Wavedump.vcd
PAUSE

@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xsim testbench_for_procesador_behav -key {Behavioral:sim_1:Functional:testbench_for_procesador} -tclbatch testbench_for_procesador.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

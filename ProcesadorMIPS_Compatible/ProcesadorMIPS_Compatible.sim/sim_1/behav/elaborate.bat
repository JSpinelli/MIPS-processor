@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 75610f76ced747358c503a420885b3ff -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot testbench_for_procesador_behav xil_defaultlib.testbench_for_procesador -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

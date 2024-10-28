cas -tRV9E -l main.asm
@if %ERRORLEVEL% NEQ 0 goto end
cln  main.o -o  main.bin -m main.map
copy main.lst ..\SIM
copy main.bin ..\SIM
copy main.lst ..\SIM2
copy main.bin ..\SIM2
copy main.lst ..\SIM3
copy main.bin ..\SIM3
:end
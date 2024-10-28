cas -tRV9E -l main.asm -o ./build/main.bin -o ./build/main.o -o ./build/main.map -o ./build/main.lst
@if %ERRORLEVEL% NEQ 0 goto end
cln  .\build\main.o -o  .\build\main.bin -m .\build\main.map
copy .\build\main.lst ..\SIM
copy .\build\main.bin ..\SIM
:end
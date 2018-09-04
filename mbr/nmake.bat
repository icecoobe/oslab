
@echo off

rem Preparing
if not exist bin (
    mkdir bin
)

:: Build
nasm -f bin -o bin\%1.bin -l bin\%1.lst %1.asm

if not exist bin\bochsrc.bxrc (
    xcopy /Y ..\template\bochsrc.bxrc bin\
    xcopy /E /Y ..\template\bxshare bin\bxshare\
)

cd bin
if not exist system.img (
    :: Create a 10MB-HD image named "system.img" which will be used by bochsrc.bxrc
    bximage -mode=create -hd=10 -q system.img
)

:: Remove temp files which may prevent starting a new bochs instance
del /s /q system.img.lock

dd if=%1.bin of=system.img bs=512 count=1

:: Run
bochs -q -f bochsrc.bxrc

cd ..
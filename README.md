oslab
=====

## Introduction
> I must Create a System, or be enslav'd by another Man's; I will not Reason and Compare: my business is to Create. —William Blake

In the early days, engineers knew everything about computing systems: mainboard, hardware, networking, compiler and so on.
I still have many questions on computing systems even as a graduated student of CS.

After reading the interesting book - [The Elements of Computing Systems][e], I was inspired to write something from scratch.
This repo. records the practices on OS development.

*I wrote a real-mode program that can handle an old hardware, registered my own interrupt service routine, and configured the interrupts in `Intel 8259A`. And it worked. Due to some reason, I can not put it here, if you are interested in how interrupt stuffs work, ping me.*

## Links
- [MikeOS][a]
- [OSDev][b]
- [JamesM's kernel development tutorials][c]
- [Bran's Kernel Development][d]

## Assembler
[NASM][1] provides some useful features that are similar to C language.
You can define macro, trace compilation with `%warning`, and memory model is easy understood.

``` Assembly
;; macro of variable
%define BASE 0x7C00

;; constant
mbr_length equ 512

;; I hate LEA
mov byte [es:xx], XXXh

;; like pointer in C
mov si, msg
mov word target, 0x7E00
jmp [target] 

msg     db 'Hello World'
target  dw 0x0

;; compilation trick
size equ ($ - start)
%if size+2 > 512
    %error "[ERROR] code is too large for boot sector"
%else
    %warning Nasm version: __NASM_VER__
    %warning Current date: __DATE__ __TIME__
    %warning Current bits mode: __BITS__
%endif
```

## Editor
[Visual Studio Code][2] is good for me with useful extensions:
- [x86 and x86_64 Assembly][3]
- [hexdump for VSCode][4]

With these extensions, integrated terminal and the following `nmake.sh`(or `nmake.bat`), I could just focus on editor and coding.

## Emulator
- VirtualBox: best performance and fully support for running os.
- DOSBox or DOSEmu: useful for dos program, you can debug your *.COM file with debug.exe
- QEMU
- Bochs: It's useful for debugging. However, you shouldn't expect the performance.

## Build & Run
### Use `nmake.sh`

```
cd bootloader
./nmake.sh gos
```

After building, the emulator will start automatically.

### Makefile
Recently I was working with `nmake.sh`, later I will improve the Makefile.

``` Shell
cd bootloader
make name=gos
cd bin
```

## Screenshot
![Gauss calculation][5]
![][6]
![][7]
![][8]

---------------------------------------------

Hope these will help you.

[1]:https://nasm.us
[2]:https://code.visualstudio.com/
[3]:https://marketplace.visualstudio.com/items?itemName=13xforever.language-x86-64-assembly
[4]:https://marketplace.visualstudio.com/items?itemName=slevesque.vscode-hexdump
[5]:https://raw.githubusercontent.com/icecoobe/oslab/master/screenshots/gauss.png
[6]:https://raw.githubusercontent.com/icecoobe/oslab/master/screenshots/vram.gif
[7]:https://raw.githubusercontent.com/icecoobe/oslab/master/screenshots/rect_msg.png
[8]:https://raw.githubusercontent.com/icecoobe/oslab/master/screenshots/loader-1.png

[a]:http://mikeos.sourceforge.net/
[b]:http://wiki.osdev.org/Main_Page
[c]:http://www.jamesmolloy.co.uk/tutorial_html/index.html
[d]:http://www.osdever.net/bkerndev/Docs/intro.htm
[e]:https://mitpress.mit.edu/books/elements-computing-systems
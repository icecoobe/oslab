
Boot sector-2
============
We did practices on stage-1: MBR code for a long time. Now it's time to move on.

This demo is a beginning where we will try to load data and programs into RAM. After that, we will hand the control to the loaded programs. Just like a stage2-bootblock progsdsd

## What does this  project do?
This project contains two parts: boot.asm and sector2.asm.
boot code will load the sector2 code into RAM, then jmp to where sector2 code lay.

##boot.asm
It's like boot.s in linux 0.11, and is a MBR code. This code will be first loaded when pc is power-on.

##sector2.asm
Well, it's a simple grub-like program. I didn't finish the basics of a grub.
It's just a practice. I will write a stage-2 booting code which will load the kernel. Yeah, next time, it will be another grub but more simple. Just for fun.

## How to build and deploy
I combine the making and deploying. You can use udisk.sh. 
>==Note I assume your U-disk is marked as /dev/sdc. You can change that in udisk.sh.==

In GNU Linux
>$ sh ./udisk.sh

You will prompt the sudo stuff.

##Others
boot code should be smaller than 446 bytes(include 446 bytes), that will not break up the DPT(Disk Patition Table, 64 bytes)

Sector2 code is 512 bytes for simple. Larger than a sector will bring many problems. The size-free code will be next topic. 


#Enjoy it, have fun!

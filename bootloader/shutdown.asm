
;;; shutdown.asm
;;; Shutdown pc
;;;

%define BOOTLOADER

	
%ifdef BOOTLOADER
	org 07c00h
%else
	org 100h
%endif

section .text
shutdown:
	mov  AX,  5307h  
	mov  BX,  1  
	mov  CX,  3  
	int  15h

%ifdef BOOTLOADER	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
%endif

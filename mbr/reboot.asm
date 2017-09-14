
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
	;; ffff0h处只有一句跳转语句
	;; dosbox中是jmp f000:12c0
	;; 1.裸机上未实验
	;; 2.dosbox中会导致重启
	;; 3.vbox上也会导致无限重启
	jmp 0xffff:0000 

%ifdef BOOTLOADER	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
%endif

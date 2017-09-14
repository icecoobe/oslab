
;; Set org address for different target
;; you should define the target before include this file
%ifdef BOOTLOADER
    %define  ORG_ADDRESS 7c00h
%elifdef DOS
    %define  ORG_ADDRESS 100h
%else
    %define  ORG_ADDRESS 0h
%endif

%define BOOTFLAG 0xAA55

;; It's your duty to make sure that
;; current size must small than 512 bytes
;; before use this macro.
%macro FitBootloaderto512WithZero 0
    %ifdef BOOTLOADER
        times (512-($-$$) - 2)	db 0 
    %endif
%endmacro

;; Depends on the target.
;; if bootloader, add the flag in the end.
;; otherwise do nothing.
%macro ADDBOOTFLAG 0
    %ifdef BOOTLOADER
        db 0x55, 0xAA
    %endif
%endmacro

;; 不保留分区表, 填充剩余空间
%macro FillSpaceLeftWithZeroFor512 0
	times (512-($-$$) - 2)	db 0 
%endmacro

;; 保留分区表(DPT), 填充剩余空间
;; 这个需要保证原先的MBR扇区是有效的引导扇区
;; 也就是末尾包含引导有效的标识
%macro FillSpaceLeftWithZeroFor512_KeepDPT 0
	times (446-($-$$))	db 0 
%endmacro



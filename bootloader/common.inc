
;; Set org address for different target
;; you should define the target before include this file
%ifdef BOOTLOADER
    %define  ORG_ADDRESS 07c0h
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

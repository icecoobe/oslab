;;=============================================================================
;; mbr.asm
;;
;; A sample of mbr program
;;
;; Compile: 
;; $ nasm -f bin -o mbr.bin -l mbr.lst mbr.asm
;;
;; Run in bochs:
;; $ bximage -mode=create -hd=10 -q system.img
;; $ dd if=mbr.bin of=system.img seek=0 bs=512 count=1 conv=notrunc
;; $ bochs -q -f bochsrc
;;=============================================================================

    [bits 16]

    org 07c00h

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    ;; clear screen 
    mov ax, 0x0003
    int 0x10

    call DispStr
    jmp $   ;; Endless loop

DispStr:
    mov ax, BootMessage
    mov bp, ax          ;; ES:BP = address of string
    mov cx, 16          ;; CX = length of string
    mov ax, 1301h       ;; AH = 13,  AL = 01h
    mov bx, 000ch       ;; page num: 0(BH = 0) bg:black fg:red(BL = 0Ch, highlight)
    mov dl, 0
    int 10h
    ret
;;=============================================================================

;;-----------------------------------------------------------------------------
;; Data
BootMessage:  db "Hello, OS world!"
;;=============================================================================

;;-----------------------------------------------------------------------------
;; to enusre current file size smaller than 512 bytes
size equ ($ - start)

%if size+2 > 512
%error "[ERROR] code is too large for boot sector"
%else
%warning Nasm version: __NASM_VER__
%warning Current date: __DATE__ __TIME__
%warning Current bits mode: __BITS__
%endif

;;-----------------------------------------------------------------------------
;; Padding & Signature
times  510-($-$$) db 0  ;; to enusre object bin file in fixed size (512 bytes)
signature dw  0xaa55
;;=============================================================================

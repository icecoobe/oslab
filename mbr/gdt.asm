
%include "inc/gdt.inc"

    org 0x7c00

    mov ax, cs
    mov ds, ax
    mov ss, ax

clear_screen:
    mov ax, 0x0003
    int 0x10

setup_gdt:
    mov si, gdt
    xor ax, ax
    mov es, ax
    mov di, [gdt_base]
    mov cx, gdt_size;32
    rep movsb

main:
    lgdt [gdtr]

    Enable_A20
    cli         ;保护模式下中断机制尚未建立，应禁止中断 
    Enable_ProtectMode

    ;; 仍然是运行当前的 MBR 程序，但是模式变成了保护模式
    ;; 因此，offset 需要重新计算，减去编译指定的 org 0x7c00
    ;jmp dword 0x8:flush_regs-0x7c00
    jmp dword 0x8:0x0

    [bits 32]
flush_regs:
    mov ax, 0x10
    mov gs, ax

    mov al, 'A'
    xor bx, bx
    mov cx, 5
write_vram:
    mov [gs:bx], al
    inc al
    add bx, 2
    dec cx
    jnz write_vram

halt:
    hlt

gdt:
    .null_desc:
        dq 0x0

    ; .text_seg_desc:
    ;     dd 0x7c0001ff
    ;     dd 0x00409800

    ;; 仍然是运行当前的 MBR 程序，但是模式变成了保护模式
    ;; 段的起始地址还是之前的 0x7c00，当然也可以在编译器计算好
    ;; 可以以flush_regs为新程序的起点，重新设置段地址
    ;; size: 0x7b00
    .text_seg_desc:
        dw 0x7aff       ;; limit 15-0
        ;dw 0x7c00       ;; Base 15-0
        dw flush_regs       ;; Base 15-0

        db 0x00          ;; Base 23-16
        db 1001_1110B   ;; P DPL S Type
        db 0100_0000B   ;; G DB L AVL limit19-16
        db 0x00          ;; Base 31-24

    ;;0xB8000-0xBFFFF (64 KB)
    ;;Base:0x00000000000B8000 (32bit)
    ;;limit:0x008000 (20bit)
    .vram_seg_desc:
        dw 0x7 ;;0x8000
        dw 0x8000

        db 0xB          ;; Base 23-16
        db 1001_0010B   ;; P DPL S Type
        db 110100_00B   ;; G DB L AVL limit19-16
        db 0x0          ;; Base 31-24
    
    ;; 
    ;;
    ;; limit:0x1000000 (1MB)
    .stack_seg_desc:
        dw 0x0400       ;; limit 15-0
        dw 0x0000       ;; Base 15-0

        db 0x00          ;; Base 23-16
        db 1001_0110B   ;; P DPL S Type
        db 010000_00B   ;; G DB L AVL limit19-16
        db 0x0          ;; Base 31-24
gdt_size equ ($ - gdt)


;; 这部分可以不占用data段，可以使用字面常量
;; 处理器没有规定
gdtr:
    gdt_limit dw (gdt_size - 1)     ;; MAX=2^16=64KB
    gdt_base dd 0x7e00

times 510-($-$$) db 0
     db 0x55,0xaa
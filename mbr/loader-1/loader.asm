;;=============================================================================
;; reloc.asm
;;
;; A sample loader for loading user program from hard disk.
;; Loader is saved in MBR and run after BIOS routine finished.
;;
;; Ping me via:
;; https://lukeat.me
;; https://github.com/icecoobe
;;=============================================================================

%include "disk.inc"

%define CRLF 0x0D, 0x0A
%define NULL 0x0

;; Application Config (what we may change)
;;
;; user program stored from sector-6
;; in LBA mode (NOTE: index from 0)
user_LBA_start equ 5

;; where the user program will be loaded
user_program_base equ 0x00010000 ;; DD, 32 bits
;;=============================================================================

;; User Program header info
user_program_len_offset     equ 0x0
entry_start_offset          equ 0x04
entry_segment_offset        equ 0x06
reloc_item_count_offset     equ 0x0A
reloc_table_offset          equ 0x0C
;;=============================================================================

section mbr align=16 vstart=0x7c00
    init_mbr_env:
        mov ax, cs
        mov ds, ax
        mov ss, ax
        xor ax, ax
        mov sp, ax

    clear_screen:
        mov ax, 0x0003
        int 0x10

    show_info:
        mov si, info
        call puts

    read_program_header:
        ;; here we use 32-bit space to store 20-bit address
        ;; space / 16 => cs:ip
        ;; the remainer will be in DX
        ;; and the one in AX is the segment value
        mov ax, [user_base]
        mov dx, [user_base + 0x02]
        mov bx, 16
        div bx

        ;; setup the ds,es for user program
        ;; then after jmp to user program, we can fetch header via ds
        mov ds, ax
        mov es, ax

        ;; read program header from disk
        ;; DI:SI LBA address
        xor di, di
        mov si, user_LBA_start
        xor bx, bx
        call read_1_sector

    calc_program_sectors_count:
        mov ax, [user_program_len_offset]
        mov dx, [user_program_len_offset + 2]
        mov bx, 512
        div bx

        ;; len < 512, dx != 0, ax == 0; cx=0, execute directly.
        ;; len >= 512
        ;;   dx != 0, check ax is 0, cx <== ax
        ;;   dx == 0, ax <== ax-1; check ax is 0, cx <== ax 
        cmp dx, 0
        jnz @1
        dec ax
    @1:
        cmp ax, 0
        jz exec_user_bin
    
    ;; There're two methods for looping.
    ;; 1. DS:Offset, read 512 bytes; Offset += 0x200;
    ;;    if user program size is larger than 64 KB, offset will overflow(0-FFFF, 64KB)
    ;;    i.e. sector count: 64 * 1024 / 512 = 128
    ;; 2. (recommended) DS:Offset, read 512 bytes; DS += 0x20;
    ;;    but DS should be saved before being processed.
    read_rest_sectors:
        mov cx, ax                 ;; loop count (remaining sector count)
        push ds                    ;; save ds, cause it will be changed locally
        .read:
            mov ax, ds
            add ax, 0x20           ;; get segment address of next 512 bytes boundary
            mov ds, ax  
                                
            xor bx, bx             ;; each time of reading, destination is DS:0x0000
            inc si                 ;; next LBA sector
            call read_1_sector
            loop .read
        pop ds                     ;; restore DS to segment of user program header 

    exec_user_bin:
        ;; Entry Segment : Entry Point
        mov dx, [entry_segment_offset + 0x02]   ;; [0x08]
        mov ax, [entry_segment_offset]          ;; [0x06]
        call calc_segment_base
        mov [entry_segment_offset], ax          ;; [NOTE] write back segment address of Entry Point

        ;; Relocation Table
        mov cx, [reloc_item_count_offset]       ;; [0x0a]
        mov bx, reloc_table_offset              ;; 0x0c
        
    relocate:
        mov dx, [bx + 0x02]        ;; High nibbles of 32-bit address
        mov ax, [bx]
        call calc_segment_base
        mov [bx], ax               ;; [NOTE] write back segment address to relocation table.
        add bx, 4                  ;; next item (like IVT item, each item needs 4 bytes)
        loop relocate 

        ;; Save neccessary environment of MBR for returing back.
        ;;
        ;; Trick: the first 4 bytes of user program memory keep length of it.
        ;;        After loading, it's useless. So we could use it saving mbr environment.
        ;; Improvements: 
        ;;   1.Setup ourown interrupt vector for returning back to loader.
        ;;   2.Spare a global space for saving context of loader as protocol just like this time.
        ;;     
        ;; [NOTE]
        ;; 1.Cause mbr ONLY use 1 section, cs == ds ==ss, so we could only store cs.
        ;;   Afterwards, we will use cs to return to mbr.
        ;;   For general purpose, you should restore CS, SS, DS if needed.
        ;; 2.x86 system usually place offset in lower 2 bytes, then segment following.
        ;;   | CS-H | (addr+4)
        ;;   | CS-L |
        ;;   |------|
        ;;   | IP-H |
        ;;   | IP-L | (addr)
        mov word [user_program_len_offset], end_of_mbr
        mov word [user_program_len_offset + 0x02], cs

        ;; Wow, finally we can jump to the memory space of user program.
        jmp far [entry_start_offset]

    end_of_mbr:
        ;; [NOTE]
        ;; must restore DS for reference msg
        ;; if needed, ss\es should be restored, too.
        mov ax, cs
        mov ds, ax
        mov si, msg
        call puts
        jmp $
;;=============================================================================

;; Read one sector (512 bytes) with LBA28 mode
;; @Source LBA address: DI:SI
;; @Destination: DS:BX
read_1_sector:
    push ax
    push bx
    push cx
    push dx

    ;; read program header from disk
    set_read_sector_count (1)

    ;; DI:SI LBA addr
    .set_LBA_sector_number:
        mov dx, 0x1f3
        mov ax, si                  ;; LBA addr [15:0]
        out dx, al                  ;; 0x1f3 (8 bit)
        inc dx

        mov al, ah                  ;; LBA addr [15:8]
        out dx, al                  ;; 0x1f4 (8 bit)
        inc dx

        mov ax, di
        ;; LBA addr [23:16]
        out dx, al                  ;; 0x1f5 (8 bit)
        inc dx

        ;; 0x1f6 bits table
        ;; ------------------------------------------------------
        ;; H: | 1 | CHS(0) or LBA(1) | 1 | master(0) or slave(1)
        ;; L:           LBA addr [27:24]
        ;; ------------------------------------------------------
        mov al, ah                  ;; LBA addr [27:24]
        or al, 0xe0                 ;; combine high & low parts
        out dx, al                  ;; 0x1f6 (8 bit)
    
        request_hd_read
        wait_for_hd_ready
        read_hd_data (256)  ;; read 1 sector

        pop dx
        pop cx
        pop bx
        pop ax

        ret
;;=============================================================================

;; Calculate segment base of the given physical address
;; @input: given address in DX:AX pair
;; @return: AX, segment address
calc_segment_base:
    push dx                          
    push bx

    ;; All given address should add runtime base address
    ;; seems equal to 'org base' for compilation
    add ax, [cs:user_base]
    adc dx, [cs:user_base + 0x02]

    ;; method-1
    ;  shr ax, 4
    ;  ror dx, 4
    ;  and dx, 0xf000
    ;  or ax, dx

    ;; method-2
    mov bx, 0x10
    div bx

    pop bx
    pop dx

    ret
;;=============================================================================

;; Print string which ends with '\0'
;; @Input: move the offset of string to SI
puts:
	lodsb
	or al, al
	jz .putsd

	mov ah, 0eh
	mov bx, 0007h
	int 10h

	jmp puts
    .putsd:
        retn
;;=============================================================================

;; .data 
user_base dd user_program_base ;; where the user program will be loaded to.
info db '==============================', CRLF
     db 'A sample loader by icecoobe.', CRLF
     db 'Ping me via:', CRLF
     db '- https://lukeat.me', CRLF
     db '- https://github.com/icecoobe', CRLF
     db '==============================', CRLF, CRLF
     db 'Loading user program ...', CRLF
     db CRLF, CRLF, NULL
msg db CRLF, '== Return to MBR ==', CRLF, NULL
;;=============================================================================

;; .bss
current_sector resb 1
program_header resb 10
;;=============================================================================

;; padding & signature
times (510-($-$$))  db 0
                    dw 0xAA55
;;=============================================================================
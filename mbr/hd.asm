
;; LBA-28 mode

;; set sector count of reading
;; port: 0x1f2
;; 8 bit mode
;; @param: sector count, 1 byte
;; if count=0, means 256 sectors
;; i.e. we can access 256*512/1024=128GB
%macro set_read_sector_count 1
    mov dx, 0x1f2
    mov al, %1
    out dx, al                  ;; 0x1f2
%endmacro
;;=============================================================================

;; start reading from the given sector
;; NOTE: use master hard disk
;; @param: start sector number, 4 bytes
%macro set_LBA_sector_number 1
    mov dx, 0x1f3
    mov al, (%1 & 0xFF)         ;; LBA addr [7:0]
    out dx, al                  ;; 0x1f3 (8 bit)
    inc dx

    mov al, ((%1 >> 8) & 0xFF)  ;; LBA addr [15:8]
    out dx, al                  ;; 0x1f4 (8 bit)
    inc dx

    mov al, ((%1 >> 16) & 0xFF) ;; LBA addr [23:16]
    out dx, al                  ;; 0x1f5 (8 bit)
    inc dx

    ;; 0x1f6 bits table
    ;; ------------------------------------------------------
    ;; H: | 1 | CHS(0) or LBA(1) | 1 | master(0) or slave(1)
    ;; L:           LBA addr [27:24]
    ;; ------------------------------------------------------
    mov al, ((%1 >> 24) & 0xF)  ;; LBA addr [27:24]
    or al, 0xe0                 ;; combine high & low parts
    out dx, al                  ;; 0x1f6 (8 bit)
%endmacro
;;=============================================================================

;; 0x1f7 OUT: read request command
;; 8 bit mode
%macro request_hd_read 0
    mov dx, 0x1f7
    mov al, 0x20                ;; read command
    out dx, al                  ;; 0x1f7 (8 bit)
%endmacro
;;=============================================================================

;; 0x1f7 IN: status
;; 8 bit mode
;; 7 - 0
;; |BUSY|x|x|x|DRQ|x|x|ERR|
;; BUSY: 1 - HD is busy.
;; DRQ: 1 - HD is ready for exchanging data.
;; ERR: 1 - Something is wrong, read port 0x1f1
%macro wait_for_hd_ready 0
        mov dx, 0x1f7
    .wait:
        in al, dx
        and al, 0x88
        cmp al, 0x08 ;; check whether hd is ready (BUSY=0,DRQ=1,ERR=0)
        jnz .wait
%endmacro
;;=============================================================================

;; read data from hd via port 0x1f0 (16 bit mode)
;; @param: count of word, 2 bytes
;; total size: param * 2 (bytes)
%macro read_hd_data 1
        mov cx, %1
        mov dx, 0x1f0
    .readw:
        in ax, dx
        mov [bx], ax    ;; save data to DS:BX
        add bx, 2
        loop .readw
%endmacro
;;=============================================================================

org 0x7c00

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    set_read_sector_count 2
    set_LBA_sector_number 0x84211248

    jmp $
;;=============================================================================

times (510 - ($-$$)) db 0
dw 0xaa55
;;=============================================================================
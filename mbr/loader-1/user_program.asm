;;=============================================================================
;; user_program.asm
;; 
;; A sample user program for demostrating program loading.
;; There are two code segments, two data segments, one stack segment.
;;
;; Routine:
;; 1.execute 1st code segment using 1st data segment.
;; 2.jump to 2nd code segment, then return to 1st code segment.
;; 3.change data segment to 2nd data segment
;;
;; Ping me via:
;; https://lukeat.me
;; https://github.com/icecoobe
;;=============================================================================

;;struct program_header
;;  int32_t length;
;;  int16_t entry_offset;
;;  int16_t entry_segment;
section header vstart=0
    ;; At first, I use the following data to verify disk operation
    ;;dummy db 0x12,0x34,0x56,0x78,0x09
    ;;     db 0xa, 0xb, 0xc, 0xd,0xe
    program_length dd program_end ; 00

    ;; information of prgram entry
    code_entry  dw start                ;; offset [04]
                dd section.code_1.start ;; segment address [06]

    ;; reloc item count
    reloc_table_len dw (header_end - code_1_segment) / 4 ; [0a]

    ;; .reloc table
    code_1_segment dd section.code_1.start ; [0c]
    code_2_segment dd section.code_2.start ; [10]
    data_1_segment dd section.data_1.start ; [14]
    data_2_segment dd section.data_2.start ; [18]
    stack_segment  dd section.stack.start  ; [1c]

    header_end:
;;=============================================================================

section code_1 align=16 vstart=0
;; string must end with '\0'
;; mov si, xx
;; call puts
;; [TODO]
;; mov ax, xx
;; push xx
;; call puts
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

start:
    ;; Setup stack
    mov ax, [es:stack_segment]
    mov ss, ax
    mov sp, stack_end

    ;; Setup data segment-1
    ;; and show the string inside it
    mov ax, [es:data_1_segment]
    mov ds, ax
    mov si, msg_1
    call puts

    push word [es:code_2_segment]   ;; CS
    mov ax, begin
    push ax ;; IP
    retf ;; jmp far cs:ip [TODO] check the ret instruction

continue:
    mov ax, [es:data_2_segment]
    mov ds, ax
    mov si, msg_2
    call puts

return_to_mbr:
    push word [es:program_length + 0x02]
    push word [es:program_length]
    retf

end:
    jmp $
;;=============================================================================

section code_2 align=16 vstart=0
;; Here we just return to code_1
begin:
    push word [es:code_1_segment]  ;; CS
    mov ax, continue
    push ax ;; IP
    retf
;;=============================================================================

section data_1 align=16 vstart=0
    ;; A character array ends with '\0'
    msg_1   db '+++++++++++++++++++++++++++', 13, 10
            db 'This is message from data_1', 13, 10
            db '---------------------------', 13, 10, 0
;;=============================================================================

section data_2 align=16 vstart=0
    ;; A character array ends with '\0'
    msg_2   db '+++++++++++++++++++++++++++', 13, 10
            db 'This is message from data_2', 13, 10
            db '---------------------------', 13, 10, 0
;;=============================================================================

section stack align=16 vstart=0
    resb 256
stack_end: ;; bottom of stack
;;=============================================================================

section trail align=16
program_end:
;;=============================================================================
    
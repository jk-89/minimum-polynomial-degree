; Helper file for printing a value which currently is present in rax register.

SYS_WRITE       equ 1
SYS_EXIT        equ 60
STDOUT_FILENO   equ 1

section .rodata

hex_list:       db "0123456789abcdef"

section .text

print_char:
        push     rdi
        push     rsi
        push     rdx
        push     rcx
        push     r11
        push     rax

        mov      eax, SYS_WRITE
        mov      edi, STDOUT_FILENO
        mov      rsi, rsp
        mov      edx, 1
        syscall

        pop      rax
        pop      r11
        pop      rcx
        pop      rdx
        pop      rsi
        pop      rdi
        ret

print_rax:
        push     rax
        push     r9
        push     rcx
        mov      r9, rax
        mov      ecx, 16
.loop:
        mov      rax, r9
        shr      rax, 60
        mov      al, [hex_list + rax]
        call     print_char
        shl      r9, 4
        dec      ecx
        jnz      .loop

        mov      eax, `\n`
        call     print_char

        pop      rcx
        pop      r9
        pop      rax
        ret
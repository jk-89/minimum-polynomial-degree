global polynomial_degree

section .text

polynomial_degree:
    push    rbx                     ; ABI requirements
    push    r12
    push    r13

    mov     r9, rsi                 ; r9: number of chunks needed in bigint
    add     r9, 95                  ;     subtraction (for one number)
    shr     r9, 6                   ; r9 = floor((n + 64 + 32 - 1) / 64)
    inc     r9                      ; making sure that no overflow will occur

    mov     r10, r9                 ; r10: size of chunks but in bytes
    shl     r10, 3                  ; r10 = 8 * r9

    mov     rax, rsi                ; r11: overall size of all chunks in bytes
    mul     r10
    mov     r11, rax                ; r11 = n * r10

    sub     rsp, r11                ; reserving memory on stack
    mov     r13, r11                ; will need it to shift stack pointer at the end of program

    mov     rcx, rsp                ; rcx: which bigint is being filled now
    xor     rbx, rbx

.fill_array:                        ; filling bigints array with content of array y from input
    cmp     rbx, rsi
    jge     .end_fill_array

    mov     r8d, [rdi + rbx * 4]    ; reading number from input array

    xor     r12, r12
    cmp     r8d, 0
    setge   r12b                    ; checking if number is negative
    dec     r12                     ; r12: -1 if number is negative, 0 otherwise

    mov     rax, r12                ; representation in U2 of -1 is only ones
    shl     rax, 32
    or      r8, rax                 ; filling upper 32 bytes of r8 with 1/0
    mov     qword [rcx], r8         ; first chunk is assigned from array y

    xor     rdx, rdx
    inc     rdx

.fill_bigint:                       ; if number is negative we fill bigint with
    cmp     rdx, r9                 ; 1-bits, otherwise with 0-bits
    jge     .end_fill_bigint

    mov     qword [rcx + rdx * 8], r12

    inc     rdx
    jmp     .fill_bigint
.end_fill_bigint:

    add     rcx, r10                ; bigint array pointer goes to next number
    inc     rbx
    jmp     .fill_array
.end_fill_array:


    mov     rbx, -1                 ; rbx: result of function, polynomial degree
.answer_loop:
    xor     rdx, rdx

.check_loop:                        ; checking if all bytes are 0 to finish loop
    cmp     rdx, r11
    jge     .check_loop_okay

    mov     al, [rsp + rdx]         ; testing each byte of bigint array
    test    al, al
    jnz     .end_check_loop

    inc     rdx
    jmp     .check_loop
.check_loop_okay:
    jmp     .end_answer_loop

.end_check_loop:


    dec     rsi                     ; number of checked bigints decreases by one
    sub     r11, r10                ; 'forgetting' last bigint

    mov     rcx, rsp                ; rcx: pointer to processed chunk
    xor     rdx, rdx
.subtraction_loop:
    cmp     rdx, rsi
    jge     .end_subtraction_loop

    xor     r8, r8
    xor     rax, rax
.chunk_by_chunk_loop:
    cmp     r8, r9
    jge     .end_chunk_loop

    bt      rax, 0                  ; restoring CF from previous subtraction
    mov     r12, [rcx + r10]
    sbb     [rcx], r12              ; subtract with borrow
    setc    al                      ; saving CF for the next sbb

    add     rcx, 8                  ; pointer goes to next chunk
    inc     r8
    jmp     .chunk_by_chunk_loop
.end_chunk_loop:

    inc     rdx
    jmp     .subtraction_loop
.end_subtraction_loop:

    inc     rbx
    jmp     .answer_loop
.end_answer_loop:

    mov     rax, rbx                ; saving answer

    add     rsp, r13
    pop     r13
    pop     r12
    pop     rbx
    ret

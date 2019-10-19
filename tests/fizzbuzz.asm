section .data
    .dec blank 0x10/

_start: 
    jmp fizzbuzz 
fizzbuzz:
    push ax
    push bx
    push cx
    push dx
    mov ax, 0
    push ax
    jmp fizzbuzz_loop
fizzbuzz_loop:
    pop ax
    inc ax
    cmp ax, 101
    je fizzbuzz_done
    push ax
    mov cx, ax
    mod cx, 3
    cmp cx, 0
    je fizzbuzz_fizz
    mov cx, ax
    mod cx, 5
    cmp cx, 0
    je fizzbuzz_buzz
    jne fizzbuzz_none
fizzbuzz_fizz:
    mov ax, 1
    mov bx, 1
    mov cx, Fizz/
    syscall
    pop ax
    push ax
    mov cx, ax
    mod cx, 5
    cmp cx, 0
    je fizzbuzz_buzz
    jne fizzbuzz_nobuzz
fizzbuzz_buzz:
    mov ax, 1
    mov bx, 1
    mov cx, Buzz
    syscall
    jmp fizzbuzz_loop
fizzbuzz_none:
    mov bx, 1
    pop ax
    push ax
    mov cx, ax
    mov ax, 1
    syscall
    jmp fizzbuzz_loop
fizzbuzz_nobuzz:
    mov ax, 1
    mov bx, 1
    mov cx, [blank]
    syscall
    jmp fizzbuzz_loop
fizzbuzz_done:

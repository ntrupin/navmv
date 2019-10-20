section .data:
    .inc lib/math.asm

_start:
    ; Factorial
    mov ax, 1
    mov bx, 1
    mov cx, 5!: /
    syscall
    mov ax, 5
    call fact
    mov cx, ax
    mov ax, 1
    mov bx, 1
    syscall
    ; Power
    mov ax, 1
    mov bx, 1
    mov cx, 5^3: /
    syscall
    mov ax, 5
    mov bx, 3
    call pow
    mov cx, ax
    mov ax, 1
    mov bx, 1
    syscall
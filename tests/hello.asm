section .data:
    .dec HELLO Hello, world!

_start:
    mov ax, 1
    mov bx, 1
    mov cx, [HELLO]
    syscall
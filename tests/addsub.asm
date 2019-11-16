_start:
    mov ax, 1
    mov bx, 1
    mov cx, 1
    add cx, 1
    syscall
    mov cx, 4
    sub cx, 1
    syscall
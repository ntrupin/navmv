_start:
    mov ax, 0
    mov bx, https://example.com
    mov cx, SITE
    syscall
    mov ax, 1
    mov bx, 1
    mov cx, [SITE]
    syscall
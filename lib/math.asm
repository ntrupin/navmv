fact:
    jmp fact_enter
fact_enter:
    cmp cx, 1
    je fact_end
    sub cx, 1
    mul ax, cx
    jmp fact_enter
fact_end:
    pop dx
    pop cx
    pop bx
    ret

pow:
    push cx
    push dx
    mov cx, ax
pow_enter:
    cmp bx, 1
    je pow_end
    mul ax, cx
    sub bx, 1
    jmp pow_enter
pow_end:
    pop dx
    pop bx
    ret
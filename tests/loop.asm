section .data:
    .dec WELCOME 0x10Welcome to the NAVM example! Type help to access the help menu, or exit to quit.0x10
    .dec PROMPT $~> /
    .dec INVALID Invalid command : /
    .dec BLANK 0x10/
    .dec INFOCMD info
    .dec INFOMAN info | displays session info
    .dec INFORES NAVM 0.0.1
    .dec HELPCMD help
    .dec HELPMAN help | displays the help menu
    .dec HELPRES 0x10Help Menu0x10------------------------------
    .dec EXITCMD exit
    .dec EXITMAN exit | exits the session

_start:
    mov ax, 1
    mov bx, 1
    mov cx, [WELCOME]
    syscall
    jmp _repl
_repl:
    mov ax, 1
    mov bx, 1
    mov cx, [PROMPT]
    syscall
    mov ax, 0
    mov bx, 0
    mov cx, INPUT
    syscall
    mov cx, [INPUT]
    cmp cx, [INFOCMD]
    je _info
    cmp cx, [HELPCMD]
    je _help
    cmp cx, [EXITCMD]
    je _exit
    jne _invalid
    jmp _repl
_info:
    mov ax, 1
    mov bx, 1
    mov cx, [INFORES]
    syscall
    jmp _repl
_help:
    mov ax, 1
    mov bx, 1
    mov cx, [HELPRES]
    syscall
    mov cx, [HELPMAN]
    syscall
    mov cx, [INFOMAN]
    syscall
    mov cx, [EXITMAN]
    syscall
    mov cx, [BLANK]
    syscall
    jmp _repl
_invalid:
    mov ax, 1
    mov bx, 1
    mov cx, [INVALID]
    syscall
    mov cx, [INPUT]
    syscall
    jmp _repl
_exit:
# navmv

Noah's Assembly Virtual Machine - V

## syntax

The assembler follows [Intel Syntax](https://en.wikipedia.org/wiki/X86_assembly_language#syntax), meaning
- Destination before source     | `mov ax, 5`

In a call with two operands, the first must always be a valid register.

## registers

`ax`, `bx`, `cx`, and `dx`.

Each register can hold an integer or string value.

## constants

Constants are declared in the `.data` section of the program, and can be referenced within the program using `[NAME]`.

Constants cannot be reassigned at runtime.

## variables

Variables can only be assigned through user input or through usage of `xchg`, and caan be referenced within the program using `[NAME]`. However, at initial assignment, they are referenced by `NAME`.

## opcodes

**mov** : moves the source value into the destination register.

**cmp** : compares two values. Sets the PSW flag to 1 if true.

**add** : adds the source value to the destination register.

**sub** : subtracts the source value from the destination register.

**mul** : multiplies the destination register by the source value.

**div** : divides the destination register by the source value.

**mod** : moves the remainder of destination/source to the destination register.

**shl** : left-shifts the destination register by the source value.

**shr** : right-shifts the destination register by the source value.

**xor** : xor's

**inc** : increments the destination register by 1.

**dec** : decrements the destination register by 1.

**jmp** : jumps to the specified label.

**jnz** : if the previous line is not zero, jumps to the specified label.

**jz** : if the previous line is zero, jumps to the specified label.

**je** : if the PSW flag is 1, jumps to specified label.

**jne** : if the PSW flag is 0, jumps to the specified label.

**prn** : prints the ASCII equivalent of an integer.

**hlt** : halts the assembler.

**push** : pushes the provided register to the runtime stack.

**pop** : pops the runtime stack into the given register.

**ret** : returns to where the function was called.

**call** : jump to the beginning of the specified function.

**syscall** : make a syscall (read, write, etc)

**nop** : do nothing.

**xchg** : exchange the values in the destination and source registers.
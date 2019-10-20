module main

import os
import readline
import http

struct Stack {
	mut: top int
	     capacity int
         array []string
}

fn create_stack(capacity int) Stack {
    stack := Stack {
        top: -1
        capacity: capacity
        array: []string
    }
    return stack
}

fn (stack Stack) is_full() bool {
    return stack.top == stack.capacity-1
}

fn (stack Stack) is_empty() bool {
    return stack.top == -1
}

fn (stack mut Stack) push(item string) {
    if stack.is_full() {
        return
    }
    stack.top+=1
    stack.array << item
}

fn (stack mut Stack) pop() string {
    if stack.is_empty() {
        return ""
    }
    stack.top-=1
    mut new := []string
    mut i := 0
    for i <= stack.top {
        new << stack.array[i]
        i++
    }
    ret := stack.array[stack.top+1]
    stack.array = new
    return ret
}

fn (stack Stack) peek() string {
    if stack.is_empty() {
        return ""
    }
    return stack.array[stack.top]
}

fn make_ascii_list() map[string]int {
    mut al := map[string]int
    chars := [" ","!",'"','#','$','%','&',"'",'(',')','*','+',",","-",".","/","0","1","2","3","4","5","6","7","8","9",
              ":",";","<","=",">","?","@","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S",
              "T","U","V","W","X","Y","Z","[","\\","]","^","_","`","a","b","c","d","e","f","g","h","i","j","k","l","m",
              "n","o","p","q","r","s","t","u","v","w","x","y","z","{","|","}","~"] 
    for index, chara in chars {
        al[chara] = index+32
    }
    return al
}

fn make_str_list() map[string]string {
    mut sl := map[string]string
    for key, value in make_ascii_list() {
        sl[value.str()] = key
    }
    return sl
}

fn stob(input string) string {
    al := make_ascii_list()
    n := input.len
    mut i := 0
    mut fin := ""
    mut bin := ""
    for i < n {
        mut val := al[input[i].str()]
        for val > 0 {
            if val % 2 == 0 {
                bin += "0"
            } else {
                bin += "1"
            }
            val /= 2
        }
        bin = bin.reverse()
        for bin.len % 8 != 0 {
            bin = "0" + bin
        }
        fin += bin
        bin = ""
        i+=1
    }
    return fin
}

fn power(x int, y int) int { 
    if y == 0 {
        return 1
    } else if y % 2 == 0 {
        return power(x, y / 2) * power(x, y / 2)
    } else {
        return x * power(x, y / 2) * power(x, y / 2)
    }
} 

fn btos(input string) string {
    mut i := 0
    mut j := 0
    mut ninput := input
    mut output := ""
    mut str := ""
    for ninput.len % 8 != 0 {
        ninput = "0" + ninput
    }
    len := ninput.len/8
    for i < len {
        set := ninput.substr(i*8, i*8+8)
        mut new := 0
        for j<8 {
            new += set.substr(j,j+1).int()*power(2, 7-j)
            j+=1
        }
        output += new.str() + "\n"
        j=0
        i+=1
    }
    sl := make_str_list()
    for line in output.split("\n") {
        str += sl[line]
    }
    return str
}

fn binadd(x string, y string) string {
    if x[0].is_digit() && y[0].is_digit() {
        return stob((x.int() + y.int()).str())
    } else {
        return stob(x + y)
    }
}

fn binsub(x string, y string) string {
    if x[0].is_digit() && y[0].is_digit() {
        return stob((x.int() - y.int()).str())
    } else {
        return stob(x.replace(y, ""))
    }
}

fn binmul(x string, y string) string {
    if x[0].is_digit() && y[0].is_digit() {
        return stob((x.int() * y.int()).str())
    } else {
        return stob(x.repeat(y.int()))
    }
}

fn interpret(program string) {
    mut stack := create_stack(8000)
    mut lines := program.split("\n")
    mut reg := map[string]string
    reg['ax'] = ""
    reg['bx'] = ""
    reg['cx'] = ""
    reg['dx'] = ""
    mut mem := map[string]string
    mut cmd := ""
    mut args := []string
    mut psw := 0
    mut cf := -1
    mut i := 0
    mut line := ""
    for !lines[i].contains("section .data") {
        if i < lines.len-1 {
            i+=1
        } else {
            break
        }
    }
    if lines[i].contains("section .data") {
        for !lines[i].contains("_start:") {
            if lines[i].contains(".dec ") {
                mem[lines[i].split(" ")[1]] = stob(lines[i].split(" ").slice(2,lines[i].split(" ").len).join(" "))
            } else if lines[i].contains(".inc ") {
                mut file := os.read_file(lines[i].split(" ")[1]) or {
                    panic(err)
                }
                file = file.replace("    ", "").replace("  ", "")
                lines = (file + ("\n" + lines.join("\n"))).split("\n")
                i=i+file.split("\n").len
            }
            i+=1
        }
    }
    i=0
    for !lines[i].contains("_start:") {
        if i < lines.len-1 {
            i+=1
        } else {
            println("No _start symbol found : halting assembler")
            return
        }
    }
    for i < lines.len {
        line = lines[i]
        if line[line.len-1].str() == " " {
            line = line.substr(0, line.len-1)
        }
        cmd = ""
        args = []string
        if line == "" || line.contains(";") {
            i+=1
            continue
        }
        if line.contains(" ") {
            cmd = line.split(" ")[0]
        } else {
            cmd = line
        }
        if line.contains(", ") {
            args << line.split(" ").slice(1, line.split(" ").len).join(" ").split(", ")
        } else {
            if line.contains(" ") {
                args << line.split(" ")[1]
            } else {
                args << ""
            }
        }
        if args.len >= 2 {
            if (args[1] == "ax" || 
               args[1] == "bx" ||
               args[1] == "cx" ||
               args[1] == "dx") && 
               (!args[1].contains("[") &&
               !args[1].contains("]")) {
                   args[1] = btos(reg[args[1]])
            } else if args[1].contains("[") &&
                      args[1].contains("]") {
                          args[1] = btos(mem[args[1].replace("[", "").replace("]", "")])
            }
            if (args[0] != "ax" && 
               args[0] != "bx" &&
               args[0] != "cx" &&
               args[0] != "dx") && 
               (!args[0].contains("[") &&
               !args[0].contains("]")) {
                    println('Line ${i+1} : Invalid register "${args[0]}" : halting assembler')
                    return
            }
        }
        if cmd == "mov" {
            reg[args[0]] = stob(args[1])
        } else if cmd == "cmp" {
            if reg[args[0]] == stob(args[1]) {
                psw = 1 
            } else {
                psw = 0 
            }
        } else if cmd == "add" {
            reg[args[0]] = binadd(btos(reg[args[0]]), args[1])
        } else if cmd == "sub" {
            reg[args[0]] = binsub(btos(reg[args[0]]), args[1])
        } else if cmd == "mul" {
            reg[args[0]] = binmul(btos(reg[args[0]]), args[1])
        } else if cmd == "div" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() / args[1].int()).str())
        } else if cmd == "mod" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() % args[1].int()).str())
        } else if cmd == "shl" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() << args[1].int()).str())
        } else if cmd == "shr" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() % args[1].int()).str())
        } else if cmd == "xor" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() ^ args[1].int()).str())
        } else if cmd == "and" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() & args[1].int()).str())
        } else if cmd == "or" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() | args[1].int()).str())
        } else if cmd == "inc" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() + 1).str())
        } else if cmd == "dec" {
            reg[args[0]] = stob((btos(reg[args[0]]).int() - args[1].int()).str())
        } else if cmd == "jmp" {
            i = 0
            for lines[i] != (args[0] + ":") {
                i+=1
            }
        } else if cmd == "jnz" {
            if btos(reg[lines[i-1].split(" ")[1]]) != "0" {
                i = 0
                for lines[i] != (args[0] + ":") {
                    i+=1
                }
            }
        } else if cmd == "jz" {
            if btos(reg[lines[i-1].split(" ")[1]]) == "0" {
                i = 0
                for lines[i] != (args[0] + ":") {
                    i+=1
                }
            }
        } else if cmd == "je" {
            if psw == 1 {
                psw = 0
                i = 0
                for lines[i] != (args[0] + ":") {
                    i+=1
                }
            }
        } else if cmd == "jne" {
            if psw == 0 {
                i = 0
                for lines[i] != (args[0] + ":") {
                    i+=1
                }
            }
        }else if cmd == "prn" {
            print(btos(reg[args[0]]))
        } else if cmd == "hlt" {
            return
        } else if cmd == "push" {
            stack.push(reg[args[0]])
        } else if cmd == "pop" {
            reg[args[0]] = stack.pop()
        } else if cmd == "ret" {
            if cf == -1 {
                println("Line ${i+1} : Invalid return in non-function : halting assembler")
                break
            } else {
                i = cf
                cf = -1
            }
        } else if cmd == "call" {
            cf = i
            i = 0
            for lines[i] != (args[0] + ":") {
                i+=1
            }
        } else if cmd == "syscall" {
            if btos(reg["ax"]) == "1" {
                if btos(reg["bx"]) == "1" {
                    stdo := btos(reg["cx"]).replace("0x10", "\n")
                    if stdo[stdo.len-1].str() == '/' {
                        print(stdo.substr(0,stdo.len-1))
                    } else {
                        println(stdo)
                    }
                }
            } else if btos(reg["ax"]) == "0" {
                if btos(reg["bx"]) == "0" {
                    uinput := readline.read_line("") or {
                        i+=1
                        continue
                    }
                    mem[btos(reg["cx"])] = stob(uinput.replace("\n", ""))
                } else if btos(reg["bx"]).contains("http://") {
                    println("NAVM does not support making non-secure http requests.")
                    i+=1
                    continue
                } else if btos(reg["bx"]).contains("https://") {
                    resp := http.get(btos(reg["bx"])) or {
	                    panic(err)
                    }
                    mem[btos(reg["cx"])] = stob(resp.text)
                }
            }
        } else if cmd == "nop" {
            i+=1
            continue
        } else if cmd == "xchg" {
            first := reg[args[0]]
            second := reg[args[1]]
            reg[args[0]] = first
            reg[args[1]] = second
        } else {
            if !cmd.contains(":") {
                println('Line ${i+1} : Invalid operation "${cmd}" : halting assembler')
                return
            }
        }
        i+=1
    }
    if os.args.len >= 4 && os.args[3] == "-d" {
        println(reg) 
    }
}

fn repl(prog string) {
    mut program := prog
    mut cmd := readline.read_line(">>> ") or {
        panic("Could not read user input")
    }
    cmd = cmd.replace("\n", "")
    mut args := ""
    if cmd.contains(" ") && cmd[0].str() == "," {
        args = cmd.split(" ")[1]
        cmd = cmd.split(" ")[0]
    }
    if cmd == ",show" {
        if program == "\n" {
            println("
Your program is empty. Add some functions to get started.

Hint: '_start:' is always a good first line.
")
        } else {
            println(program)
        }
    } else if cmd == ",exec" {
        println("Running script...\n")
        if args != "" {
            fileprog := os.read_file(args) or {
                panic('Could not read file at ${args}')
            }
            interpret(fileprog.replace("    ", "").replace("  ", ""))
        } else {
            interpret(program.replace("    ", "").replace("  ", ""))
        }
    } else if cmd == ",clear" {
        program = "\n"
        println("Program cleared")
    } else if cmd == ",undo" {
        if program != "\n" {
            removed := program.split("\n")[program.split("\n").len-1].replace("    ", "").replace("  ", "")
            program = "\n" + program.split("\n").slice(0,program.split("\n").len-1).join("\n")
            if program != "\n" {
                program += "\n"
            }
            println('undo: removed "${removed}"')
        }
    } else if cmd == ",help" {
        println("
,help       Displays this menu
,clear      Clears the cached program
,exec       Executes the cached program
      [FILE]Executes the given file
,undo       Removes the most recent line
")  
    } else {
        if cmd.contains(":") {
            program += cmd + "\n"
        }
        else {
            program += "    " + cmd + "\n"
        }
    }
    repl(program)
}

fn main() {
    if os.args.len >= 2 {
        if os.args[1] == "run" && os.args.len>=3 {
            program := os.read_file(os.args[2]) or {
                panic('Could not read file at ${os.args[2]}')
            }
            interpret(program.replace("    ", "").replace("  ", ""))
        } else if os.args[1] == "help" {
            println("
run         Executes the provided file.
help        Displays the help menu.
")
        } else {
            println("Usage: navmv run [FILE]")
        }
    } else {
        println('
NAVMV REPL v0.1.1
Type ,help for a command list  
')
        repl("\n")
    }
}
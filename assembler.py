assembly_file= "p1_assembly"
machine_code_file = "machine_code"

instructions = {
        "ADD"    :   "00000",
        "ADDC"   :   "00001",
        "SUB"    :   "00010",
        "SUBC"   :   "00011",
        "SHL"    :   "00100",
        "SHLC"   :   "00101",
        "SHR"    :   "00110",
        "SHRC"   :   "00111",
        "INC"    :   "01000",
        "DEC"    :   "01001",
        "MSB"    :   "01010",
        "LSB"    :   "01011",
                    
        "CCC"    :   "01100",
        "SET"    :   "01101",

        "BEZ"    :   "10000",
        "BNZ"    :   "10001",
        "BEQ"    :   "10010",
        "BNE"    :   "10011",
        "BGT"    :   "10100",
        "BLT"    :   "10101",
        "SBD"    :   "10110",
                                   
        "LD"     :   "11000",
        "ST"     :   "11001",
        "MOV"    :   "11100",
        "GET"    :   "11101",
        "ACC"    :   "11110",
        "BCC"    :   "11111",

        "TARG"   :   None
}             

imms = {"ACC", "BCC", "CCC", "SBD"}

# only ACC, BCC, CCC, SBD take in immediates
# TARG is only macro

regs = {
        "$r0"   :   "0000",
        "$r1"   :   "0001",
        "$r2"   :   "0010",
        "$r3"   :   "0011",
        "$r4"   :   "0100",
        "$r5"   :   "0101",
        "$r6"   :   "0110",
        "$r7"   :   "0111",
        "$r8"   :   "1000",
        "$r9"   :   "1001",
        #"$r10"  :   "1010",
        #"$r11"  :   "1011",
        "$r12"  :   "1100",
        #"$r13"  :   "1101",
        "$r14"  :   "1110",
        "$r15"  :   "1111",
        
        "$rz"   :   "1010",
        "$rbt"  :   "1101",
        "$rbc"  :   "1110",
        "$ra"   :   "1111"
}

def int_to_bin(num):
    size = 4
    if num >= 2**size:
        print "ERR"
        return None
    s = ""
    for i in range(size):
        exp = size-1-i
        t = 2**exp
        if num >= t:
            num -= t
            s += "1"
        else:
            s += "0"
    return s

code_lines = []
labels = dict()
counter = 0
with open(assembly_file) as f:
    for line in f:
        counter += 1
        line = line.strip()
        print "line num", counter
        arr = line.split(" ")
        arr = filter(lambda x: x!="", arr)
        if len(arr) < 1: continue
        instr = arr[0].upper()
        if instr not in instructions and instr[-1] != ":": continue
        if instr[-1] == ":":
            labels[instr] = counter
            continue
        if instr == "TARG":
            code_lines.append("TARG " + instr[1])
            continue
        operand = arr[1]
        if instr in imms:
            operand = int_to_bin(int(operand))
        else:
            operand = regs[operand]
        code = instructions[instr] + operand
        code_lines.append(code)

with open(machine_code_file, 'w') as f:
    for line in code_lines:
        f.write(line + "\n")

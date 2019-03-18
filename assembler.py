assembly_file= "david_test"
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

def translate(instr, operand):
    instr = instr.upper()
    if instr in imms:
        operand = int_to_bin(int(operand))
    else:
        operand = regs[operand]
    translation = instructions[instr] + operand
    return translation

cleaned = []
counter = 0

# preprocessor - cleanup and convert to labels, targs, and machine code
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
            cleaned.append("LABEL " + instr[:-1])
        elif instr == "TARG":
            cleaned.append("TARG " + arr[1])
        else:
            cleaned.append(line)
            """
            instr = arr[0]
            operand = arr[1]
            translation = translate(instr, operand)
            cleaned.append(translation)
            """

targ_expansion = []
for line in cleaned:
    arr = line.split(" ")
    if arr[0] == "TARG":
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
    else:
        targ_expansion.append(line)

counter = 0
label_nums = dict()
removed_labels = []
for line in targ_expansion:
    arr = line.split(" ")
    if arr[0] == "LABEL":
        label = arr[1]
        if label not in label_nums:
            label_nums[label] = counter
        else:
            print "DUPLICATE LABEL ERR"
            print "Label used twice:", label
            raise Exception
    else:
        removed_labels.append(line)
        counter += 1

def targ_to_instructions(branch_num, label_num):
    # need to go from branch_num -> label_num
    difference = label_num - branch_num
    if difference == 0:
        print "weird err"
        raise Exception
    direction = 0 if difference < 0 else 1
    offset = abs(difference)
    
    if offset > 93:
        print "Too large of an offset:", offset
        raise Exception

    instructions = [0]*6

    if offset <= 15:
        instructions[0] = "acc %d" % offset
        instructions[1] = "mov $rbt"
        instructions[2] = "acc 0"
        instructions[3] = "acc 0"
        instructions[4] = "acc 0"
        instructions[5] = "sbd %d" % direction

    elif offset <= 31:
        offset = offset - 16
        instructions[0] = "bcc %d" % offset
        instructions[1] = "mov $rbt"
        instructions[2] = "acc 0"
        instructions[3] = "acc 0"
        instructions[4] = "acc 0"
        instructions[5] = "sbd %d" % direction

    elif offset <= 46:
        instructions[0] = "bcc 15"
        instructions[1] = "mov $rbt"
        offset = offset - 31
        instructions[2] = "acc %d" % offset
        instructions[3] = "add $rbt"
        instructions[4] = "acc 0"
        instructions[5] = "sbd %d" % direction

    elif offset <= 62:
        instructions[0] = "bcc 15"
        instructions[1] = "mov $rbt"
        offset = offset - 47
        instructions[2] = "bcc %d" % offset
        instructions[3] = "add $rbt"
        instructions[4] = "acc 0"
        instructions[5] = "sbd %d" % direction

    elif offset <= 77:
        instructions[0] = "bcc 15"
        instructions[1] = "mov $rbt"
        instructions[2] = "add $rbt"
        offset = offset - 62
        instructions[3] = "acc %d" % offset
        instructions[4] = "add $rbt"
        instructions[5] = "sbd %d" % direction

    elif offset <= 93:
        instructions[0] = "bcc 15"
        instructions[1] = "mov $rbt"
        instructions[2] = "add $rbt"
        offset = offset - 78
        instructions[3] = "bcc %d" % offset
        instructions[4] = "add $rbt"
        instructions[5] = "sbd %d" % direction

    return instructions


replaced_targ = removed_labels
counter = 0
for line in replaced_targ:
    arr = line.split(" ")
    branch_num = counter + 6;
    if arr[0] == "TARG":
        label = arr[1]
        label_num = label_nums[label]
        replacement = targ_to_instructions(branch_num, label_num)
        replaced_targ[counter]   = replacement[0]
        replaced_targ[counter+1] = replacement[1]
        replaced_targ[counter+2] = replacement[2]
        replaced_targ[counter+3] = replacement[3]
        replaced_targ[counter+4] = replacement[4]
        replaced_targ[counter+5] = replacement[5]
    counter += 1

translated = []
for line in replaced_targ:
    arr = line.split(" ")
    print arr
    code = translate(arr[0], arr[1])
    translated.append(code)

with open(machine_code_file, 'w') as f:
    for line in translated:
        f.write(line + "\n")

for label in label_nums:
    print label + " - " + removed_labels[label_nums[label]]

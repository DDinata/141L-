import sys
import os

if len(sys.argv) != 2:
    print "Need file name"
    raise Exception
assembly_file = sys.argv[1]

#assembly_file= "david_test"

# only ACC, BCC, SBD take in immediates
# TARG is only macro
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
        "MMM"    :   "01010",
        "LLL"    :   "01011",
                    
        "CCC"    :   "01100",
        "SET"    :   "01101",

        "BEZ"    :   "10000",
        "BNZ"    :   "10001",
        "BEQ"    :   "10010",
        "BNE"    :   "10011",
        "BGT"    :   "10100",
        "BLT"    :   "10101",

        "LD"     :   "11000",
        "ST"     :   "11001",
        "MOV"    :   "11100",
        "GET"    :   "11101",
        "ACC"    :   "11110",
        "BCC"    :   "11111",

        "TARG"   :   None
}             
imms = {"ACC", "BCC"}
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

def write_file(fname, arr):
  print "Writing to", fname
  with open(fname, 'w') as f:
      for line in arr:
          f.write(line + "\n")

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

def targ_to_instructions(branch_num, label_num):
    # need to go from branch_num -> label_num
    difference = label_num - branch_num
    if difference == 0:
        print "weird err"
        raise Exception
    direction = 0 if difference < 0 else 1
    offset = abs(difference)
    
    if offset > 255:
        print "Too large of an offset:", offset
        raise Exception

    instructions = [0]*4

    acc_offset = offset % 16
    bcc_offset = offset / 16

    comment_string = " // branch target to %d" % label_num
    instructions[0] = "acc %d" % acc_offset  + comment_string
    instructions[1] = "bcc %d" % bcc_offset  + comment_string
    instructions[2] = "mov $rbt"             + comment_string
    instructions[3] = "acc %d" % direction   + comment_string

    return instructions



# preprocessor - cleanup and convert to labels, targs, and machine code
cleaned = []
with open(assembly_file) as f:
    for line in f:
        line = line.strip()
        arr = line.split(" ")
        arr = filter(lambda x: x!="", arr)[:2]
        if len(arr) == 0: continue
        instr = arr[0].upper()
        if instr not in instructions and instr[-1] != ":": continue

        if instr[-1] == ":":
            cleaned.append("LABEL " + instr[:-1])
        elif instr == "TARG":
            cleaned.append("TARG " + arr[1])
        else:
            if len(arr) == 2:
                cleaned.append(line)
            else:
                cleaned.append(arr[0] + " $r0")  # will get converted to 0000

write_file(assembly_file+"-cleaned.log", cleaned)

# targ line expansion
targ_expansion = []
for line in cleaned:
    arr = line.split(" ")
    if arr[0] == "TARG":
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
        targ_expansion.append(line)
    else:
        targ_expansion.append(line)

write_file(assembly_file+"-expanded.log", targ_expansion)

# line recording
label_nums = dict()
unlabeled = []
for line in targ_expansion:
    arr = line.split(" ")
    if arr[0] == "LABEL":
        label = arr[1]
        if label not in label_nums:
            label_nums[label] = len(unlabeled)
        else:
            print "DUPLICATE LABEL ERR"
            print "Label used twice:", label
            raise Exception
    else:
        unlabeled.append(line)

write_file(assembly_file+"-unlabeled.log", unlabeled)

print "Label line numbers"
for label in label_nums:
    print label + "(" + str(label_nums[label]) + ") - " + unlabeled[label_nums[label]]


# targ replacement with instructions
replaced_targ = unlabeled
counter = 0
for line in replaced_targ:
    arr = line.split(" ")
    branch_num = counter + 4;
    if arr[0] == "TARG":
        label = arr[1]
        if label not in label_nums:
            print "Label does not exist:", label
            raise Exception
        label_num = label_nums[label]
        replacement = targ_to_instructions(branch_num, label_num)
        replaced_targ[counter]   = replacement[0]
        replaced_targ[counter+1] = replacement[1]
        replaced_targ[counter+2] = replacement[2]
        replaced_targ[counter+3] = replacement[3]
    counter += 1

write_file(assembly_file+"-full.log", replaced_targ)

# translate to machine code
translated = []
for line in replaced_targ:
    arr = line.split(" ")
    code = translate(arr[0], arr[1])
    translated.append(code)

write_file(assembly_file+"-machine_code.log", translated)
write_file("machine_code", translated)
os.system("cp machine_code ~/Desktop/actual_project")
print "Copied over"

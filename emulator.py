OVERFLOW_FLAG_ON = True

def int_to_bit(num, size=16):
    if num >= 2**size:
        print "ERR"
        return None
    arr = [0]*size
    for i in range(size):
        exp = size-i-1
        t = 2**exp
        if num >= t:
            num -= t
            arr[i] = 1
    return arr

def bit_to_int(a):
    s = 0
    for i in range(len(a)):
        s += a[i]*2**(len(a)-i-1)
    return s

def band(a,b):
    return [a[i] & b[i] for i in range(len(a))]
def bor(a,b):
    return [a[i] | b[i] for i in range(len(a))]
def bxor(a,b):
    return [a[i] ^ b[i] for i in range(len(a))]
def ones_complement(a):
    return map(lambda x: 1-x, a)
def twos_complement(a):
    comp = ones_complement(a)
    one = int_to_bit(1, size=len(a))
    return add(comp, one)
def msb_pos(a):
    for i in range(len(a)):
        if a[i] == 1:
            return i
    return len(a)
# actual one
def msb(a):
    msb = 8
    check = int_to_bit(1)
    for i in range(8):
        if bit_to_int(a) >= bit_to_int(check):
            msb = 7-i
        check = shift(check, 0, int_to_bit(1))
    return msb

# LEFT ON 0 RIGHT ON 1
def shift(a, lr, reg):
    res = [0]*len(a)
    shift_amt = bit_to_int(reg[-5:])
    if lr == 1:
        for i in range(shift_amt, len(a)):
            res[i] = a[i-shift_amt]
    else:
        for i in range(0, len(a)-shift_amt):
            res[i] = a[i+shift_amt]
    return res

def add(a,b):
    if len(a) != len(b):
        print "ERR"
        return None
    res = [0] * len(a)
    c = 0
    for i in range(len(a)-1, -1, -1):
        x = a[i]
        y = b[i]
        res[i] = (x ^ y) ^ c
        c = (x & y) | ((x ^ y) & c)
    if c == 1 and OVERFLOW_FLAG_ON:
        print "OVERFLOW"
        return "OVERFLOW"
    return res

def sub(a,b):
    if bit_to_int(b) > bit_to_int(a):
        print "SUB ERR"
        return "SUB ERR"
    return add(a, twos_complement(b))


# TESTS
"""
for i in range(2**5):
    b = int_to_bit(i)
    if bit_to_int(b) != i:
        print "FAIL"


for i in range(2**5):
    for j in range(2**5):
        b1 = int_to_bit(i)
        b2 = int_to_bit(j)
        b3 = add(b1,b2)
        if bit_to_int(b3) != i+j:
            print "FAIL"

print add(int_to_bit(2**15), int_to_bit(2**15)) == "OVERFLOW"

five = int_to_bit(5)
sixteen = int_to_bit(16)
print shift(five, add(five,sixteen)) == int_to_bit(5*2**5)
bigint = 30144
bigbit = int_to_bit(bigint)
print shift(bigbit, five) == int_to_bit(942)

OVERFLOW_FLAG_ON = False
for i in range(2**5):
    for j in range(i+1):
        b1 = int_to_bit(i)
        b2 = int_to_bit(j)
        b3 = sub(b1,b2)
        if bit_to_int(b3) != i-j:
            print "FAIL"
            print bit_to_int(b3), i-j
OVERFLOW_FLAG_ON = True

for i in range(16):
    a = int_to_bit(65535)
    shift_reg = int_to_bit(i)
    print shift(a, 1, shift_reg)

for i in range(16):
    a = int_to_bit(65535)
    shift_reg = int_to_bit(i)
    print shift(a, 0, shift_reg)

for i in range(1,2**8):
    b = int_to_bit(i,size=8)
    m = msb(b)
    if m != msb_pos(b):
        print "FAIL"
        print m, msb_pos(b)
"""

OVERFLOW_FLAG_ON= False

def program1(div):
    out = [0] * 16

    # divisor > 2^15 -> return 0
    if bit_to_int(div) > 2**15:
        return out

    num = int_to_bit(2**15)
    m = msb(div)
    start = 7-m
    for i in range(start, 16):

        left_shift_val = 15 - i
        shift_reg = int_to_bit(left_shift_val)
        shifted_div = shift(div, 0, shift_reg)

        if bit_to_int(num) >= bit_to_int(shifted_div):
            num = sub(num, shifted_div)
            out[i] = 1

    return out

print "Output: ", program1(int_to_bit(9))


"""
def program2(num, div):
    out = [0]*23

    m = msb(div)
    start = 7-m
    for i in range(start, 24):
        left_shift_val = (15 - i) + 16
        shift_reg = int_to_bit(left_shift_val)
        shifted_div = shift(div, shift_reg)

        if bit_to_int(num) >= bit_to_int(shifted_div):
            num = sub(num, shifted_div)
            out[i] = 1

print "Output: ", program2(int_to_bit(532), int_to_bit(13))
"""

"""

def program3(num):
    x_curr = num

    for _ in range(10):
        x_next  = 0.5 * (x_curr + float(num)/x_curr)
        x_curr = x_next

    return x_curr

print "Output: ", program3(10)
import math
print "Sqtr: ", math.sqrt(10)
"""

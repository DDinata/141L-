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

# NOT TWO COMPLEMENT FORMAT
def shift(a, reg):
    res = [0]*len(a)
    # < 16 TO THE RIGHT - 0 thru 15 shifts right 0 thru 15
    # >= 16 TO THE LEFT - 16 thru 31 shifts left 0 thru 15
    shift_amt = bit_to_int(reg[-4:])
    shift_lr = reg[-5]
    if shift_lr == 0:
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
    print shift(a, shift_reg)

for i in range(16):
    a = int_to_bit(65535)
    shift_reg = int_to_bit(i+16)
    print shift(a, shift_reg)
"""


OVERFLOW_FLAG_ON= False


def program1(div):
    out = [0] * 16

    # divisor > 2^15 -> return 0
    if bit_to_int(div) > 2**15:
        return out

    num = int_to_bit(2**15)
    for i in range(16):


        right_shift_val = 15 - i
        shift_reg = int_to_bit(right_shift_val)
        shifted_num = shift(num, shift_reg)

        left_shift_val = 15 - i + 16
        shift_reg = int_to_bit(left_shift_val)
        shifted_div = shift(div, shift_reg)

        if bit_to_int(shifted_num) >= bit_to_int(div):
            num = sub(num, shifted_div)
            out[i] = 1

    return out

asdf = int_to_bit(9)
print "Output: ", program1(asdf)

def program1(div):
    out = [0] * 16

    # divisor > 2^15 -> return 0
    if bit_to_int(div) > 2**15:
        return out

    num = int_to_bit(2**15)
    for i in range(16):


        right_shift_val = 15 - i
        shift_reg = int_to_bit(right_shift_val)
        shifted_num = shift(num, shift_reg)

        left_shift_val = 15 - i + 16
        shift_reg = int_to_bit(left_shift_val)
        shifted_div = shift(div, shift_reg)

        if bit_to_int(shifted_num) >= bit_to_int(div):
            num = sub(num, shifted_div)
            out[i] = 1

    return out

asdf = int_to_bit(9)
print "Output: ", program1(asdf)

"""

def program2(a, b):
    return float(a)/b

print "Output: ", program2(10, 3)
print "Division: ", float(10)/3

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

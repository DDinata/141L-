import math
OVERFLOW_FLAG_ON = False

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

def fbit_to_float(a,start=15,end=-8):
    s = float(0)
    e = range(start,end-1,-1)
    for i in range(len(a)):
        s += a[i]*2**(e[i])
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




def program1(div):
    out = [0] * 16

    if bit_to_int(div) == 0:
        return out

    # divisor > 2^15 -> return 0
    if bit_to_int(div) > 2**15:
        return out
#    if msb $r0 == 7
#    if msb(div[:8]) == 0:
#        return out

    num = int_to_bit(2**15)

    # if left side is greater than 0
    if bit_to_int(div) >= 2**8:
        m = msb(div[:8])
        left_shift = m

    # if left side is all 0
    else:
        m = msb(div[8:])
        left_shift = m + 8

    start = 15 - left_shift;

    for _ in range(left_shift):
      div = shift(div, 0, int_to_bit(1))

    for i in range(start, 16):

        if bit_to_int(num) >= bit_to_int(div):
            num = sub(num, div)
            out[i] = 1

        div = shift(div, 1, int_to_bit(1))

    return out

def program2(num, div):
    num = num + [0]*8
    div = int_to_bit(bit_to_int(div),size=24)
    out = [0]*24

    m = msb(div[-8:])
    left_shift = 16 + m
    start = 23 - left_shift

    for _ in range(left_shift):
      div = shift(div, 0, int_to_bit(1))

    for i in range(start, 24):

        if bit_to_int(num) >= bit_to_int(div):
            num = sub(num, div)
            out[i] = 1

        div = shift(div, 1, int_to_bit(1))

    return out

# NEED TO FIGURE OUT HOW TO ROUND THIS
def program3(x_0):
    x_curr = [0]*15 + [1]

    ITERS = 100
    for _ in range(ITERS):
        # x_next  = 0.5 * (x_curr + float(x_0)/x_curr)
        # x_curr = x_next
        
        """
        a = x_curr
        # 8 most significant bits is MSB thru MSB+8
        # only shift if x_curr[:8] > 0
        left8 = x_curr[:8]
        if bit_to_int(left8) == 0:
            x_curr_truncated = x_curr[-8:]
        else:
            m = msb(left8)
            x_curr_truncated = x_curr[m:m+8]
        """

        b = program2(x_0, x_curr[8:])
        c = add(x_curr, b[:16])
        c = shift(c, 1, int_to_bit(1))
        x_curr = c

    return x_curr

"""
x = 1003
out = program1(int_to_bit(x))
print "Output:", out
print "Converted:", fbit_to_float(out,start=0,end=-15)
print "Actual:", float(1)/x

x = 2
y = 120
out = program2(int_to_bit(x), int_to_bit(y))

print "Output:", out[:16], ".", out[16:]
print "Converted:", fbit_to_float(out)
print "Actual:", float(x)/y

x = 15
out = program3(int_to_bit(x))
print "Output:", out
print "Converted:", bit_to_int(out)
print "Actual:", math.sqrt(x)
"""

"""
# program tests
for i in range(1, 2**16):
    allowed_err = 2**-15
    out = program1(int_to_bit(i))
    converted = fbit_to_float(out,start=0,end=-15)
    actual = float(1)/i
    if converted > actual or abs(converted - actual) >= allowed_err:
        print "FAIL"
        print i

for i in range(1, 2**10):
    for j in range(1, 2**4):
        allowed_err = 2**-7
        out = program2(int_to_bit(i), int_to_bit(j))
        converted = fbit_to_float(out)
        actual = float(i)/j
        if converted > actual or abs(converted - actual) >= allowed_err:
            print "FAIL"
            print i,j
"""

for i in range(1, 2**5):
    allowed_err = 1
    out = program3(int_to_bit(i))
    converted = bit_to_int(out)
    actual = math.sqrt(i)
    if abs(converted - actual) > allowed_err:
        print "FAIL"
        print i
        print converted, actual

# function tests
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

for i in range(2**5):
    for j in range(i+1):
        b1 = int_to_bit(i)
        b2 = int_to_bit(j)
        b3 = sub(b1,b2)
        if bit_to_int(b3) != i-j:
            print "FAIL"
            print bit_to_int(b3), i-j

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

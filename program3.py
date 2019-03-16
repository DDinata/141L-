def program3(num):
    x_curr = num

    for _ in range(10):
        x_next  = 0.5 * (x_curr + float(num)/x_curr)
        x_curr = x_next

    return x_curr

print "Output: ", program3(10)
import math
print "Sqtr: ", math.sqrt(10)

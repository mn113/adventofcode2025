#! /usr/bin/env python3
# Some ranges of numeric ids need analysed

import re

with open('../inputs/input02.txt') as fp:
    line_str = fp.readlines()[0]
    range_pairs = [(int(a), int(b)) for [a,b] in [piece.split('-') for piece in line_str.split(',')]]

# An id consisting of a sequence of digits repeated exactly once is invalid
def is_invalid_1(n):
    repeat_2x_digit_seq_re = r'^(\d+)\1$'
    return re.search(repeat_2x_digit_seq_re, str(n))

# An id consisting of a sequence of digits repeated once or more is invalid
def is_invalid_2(n):
    repeating_nx_digit_seq_re = r'^(\d+)\1{1,}$'
    return re.search(repeating_nx_digit_seq_re, str(n))

##
# Part 1+2
# Sum of invalid ids within the ranges
#
total_p1 = 0
total_p2 = 0

for (a, b) in range_pairs:
    for i in range(a, b + 1):
        if is_invalid_1(i):
            total_p1 += i
        if is_invalid_2(i):
            total_p2 += i

print("Part 1:", total_p1)
print("Part 2:", total_p2)

# P1: 34826702005
# P2: 43287141963

#! /usr/bin/env python3
# Scan long digit strings to combine digits into maximal numbers

with open('../inputs/input03.txt') as fp:
    digits_lines = [[int(c) for c in word] for word in [line.strip() for line in fp.readlines()]]

def scan_largest_pair_digits(digits):
    max1 = max(digits[:-1])
    max1_index = digits.index(max1)
    max2 = max(digits[max1_index + 1:])
    return max1 * 10 + max2

def scan_largest_digit_recursive(target_length = 0, digits = [], total = 0):
    if target_length == 0:
        return total

    safe_digits = digits[:len(digits) - target_length + 1]
    highest = max(safe_digits)
    highest_index = digits.index(highest)
    next_digits = digits[highest_index + 1:]
    next_total = total * 10 + highest
    return scan_largest_digit_recursive(target_length - 1, next_digits, next_total)

##
# Part 1
# Sum of largest 2-digit numbers made by scanning digits L-R in each line
#
print("Part 1:", sum([scan_largest_pair_digits(digits) for digits in digits_lines]))

##
# Part 2
# Sum of largest 12-digit numbers made by scanning digits L-R in each line
#
print("Part 2:", sum([scan_largest_digit_recursive(12, digits, 0) for digits in digits_lines]))

# P1: 17166
# P2: 169077317650774

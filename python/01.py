#! /usr/bin/env python3
# A safe dial numbered 0-100 will be turned left and right by input instructions.

with open('../inputs/input01.txt') as fp:
    turns = [(line_str[0], int(line_str.strip()[1:])) for line_str in fp.readlines()]

##
# Part 1
# How many turns leave the curpos at 0?
#
curpos = 50
zeros_hit = 0

for turn in turns:
    if turn[0] == 'R':
        curpos += turn[1]
    else:
        curpos -= turn[1]
    if curpos % 100 == 0:
        zeros_hit += 1

print("Part 1:", zeros_hit)

##
# Part 2
# How many times does curpos pass 0, considering every click?
#
curpos = 50
zeros_passed = 0

for turn in turns:
    clicks = turn[1]
    while clicks > 0:
        if turn[0] == 'R':
            curpos += 1
        else:
            curpos -= 1
        clicks -= 1
        if curpos % 100 == 0:
            zeros_passed += 1

print("Part 2:", zeros_passed)

# P1: 1040
# P2: 6027

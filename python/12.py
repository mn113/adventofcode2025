#! /usr/bin/env python3

shapes = {}
regions = []

with open('../inputs/input12.txt') as fp:
    i = 0
    for line_str in fp.readlines():
        line = line_str.strip()
        if line.endswith(":"):
            i = int(line[:-1])

        elif "#" in line or "." in line:
            if not i in shapes:
                shapes[i] = []
            shapes[i].append([c for c in line])

        elif "x" in line_str:
            bits = line.split(" ")
            ids = [int(b) for b in bits[1:]]
            w_str, h_str = bits[0].split(":")[0].split("x")
            regions.append({ "w": int(w_str), "h": int(h_str), "ids": ids })

print(shapes)
print(regions)

##
# Part 1
# How many of the regions can fit all of the presents listed?
#
def analyse_region(region):
    needed_space = sum(region["ids"]) * 3 * 3
    available_space = region["w"] * region["h"]
    return available_space >= needed_space

viabilities = [analyse_region(r) for r in regions]

print("Part 1:", len([v for v in viabilities if v == True]))
# P1: 536

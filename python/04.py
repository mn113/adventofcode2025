#! /usr/bin/env python3
# Count the accessible paper rolls in a room grid

FREE = "."
PAPER = "@"

with open('../inputs/input04.txt') as fp:
    grid = [[char for char in line_str.strip()] for line_str in fp.readlines()]
ydim = len(grid)
xdim = len(grid[0])


def grid_val(coords):
    (y, x) = coords
    return grid[y][x]

def neighbours(point):
    (y, x) = point
    up    = (max(y-1, 0), x)
    down  = (min(y+1, ydim-1), x)
    left  = (y, max(x-1, 0))
    right = (y, min(x+1, xdim-1))

    upleft = (max(y-1, 0), max(x-1, 0))
    upright = (max(y-1, 0), min(x+1, xdim-1))
    downleft = (min(y+1, ydim-1), max(x-1, 0))
    downright = (min(y+1, ydim-1), min(x+1, xdim-1))

    all_nbs = list(set([up, down, left, right, upleft, upright, downleft, downright]))
    # exclude same point
    return [nb for nb in all_nbs if not (nb[0] == y and nb[1] == x)]

def paper_neighbours(point):
    return [nb for nb in neighbours(point) if grid_val(nb) == PAPER]

def clean_grid(removables):
    for (y, x) in removables:
        grid[y][x] = FREE

def count_grid_papers():
    return len([c for row in grid for c in row if c == PAPER])

##
# Part 1 + 2
# How many rolls are removable (have fewer than 4 neighbouring rolls from 8 places?)
# How many rolls are left after all removables are removed?
#
initial_rolls = count_grid_papers()
found_p1 = False
while 1:
    removable_rolls = []
    for y in range(ydim):
        for x in range(xdim):
            point = (y, x)
            if grid_val(point) == PAPER and len(paper_neighbours(point)) < 4:
                removable_rolls.append(point)

    if not found_p1:
        print("Part 1:", len(removable_rolls))
        found_p1 = True

    clean_grid(removable_rolls)

    if len(removable_rolls) == 0:
        print("Part 2:", initial_rolls - count_grid_papers())
        break

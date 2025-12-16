#! /usr/bin/env python3
# Count the paths through a network

conns = {}

with open('../inputs/input11.txt') as fp:
    for line_str in fp.readlines():
        left, rights = line_str.strip().split(":")
        conns[left] = rights.strip().split(" ")

##
# Part 1
# Count the paths leading from 'you' to 'out'
# Simple exhaustive queue search:
initial = 'you'
numpaths = 0
to_see = [initial]
while len(to_see) > 0:
    curr, to_see = to_see[0], to_see[1:]
    if curr == 'out':
        numpaths += 1
    elif curr == initial and len(to_see) > 0:
        continue
    else:
        to_see += conns[curr]

print("Part 1:", numpaths)
# P1: 634

##
# Part 2
# How many paths from 'svr' to 'out' visit both 'dac' and 'fft'?
# Queue search with multiple start & ends:
def count_paths(starts, ends, limit = 15):
    numpaths = dict(zip(ends, [0] * len(ends)))
    chains_to_see = [[s] for s in starts]
    while len(chains_to_see) > 0:
        curr_chain, chains_to_see = chains_to_see[0], chains_to_see[1:]
        if len(curr_chain) > limit:
            break

        curr_node = curr_chain[-1]
        if curr_node in ends:
            numpaths[curr_node] += 1
        else:
            up_next = conns[curr_node]
            for upn in up_next:
                chains_to_see.append(curr_chain + [upn])

    return numpaths[ends[0]]


# After Graphviz svg analysis:
start = ['svr']
pinch1 = ['pzi', 'zyi', 'muy']
target_fft = ['fft']
# pinch2 = ['edr', 'ehw', 'vht', 'vjh', 'kqn']
pinch3 = ['rpn', 'apc', 'lpz']
# pinch4 = ['tql', 'jvl', 'cix', 'jyw', 'xct']
target_dac = ['dac']
# pinch5 = ['qdo', 'sdo', 'ire', 'you']
end = ['out']

stage1_counts = 0
for pin in pinch1:
    stage1_counts += count_paths(start, [pin], 8) * count_paths([pin], target_fft, 5)
print('S1', stage1_counts)

stage2_counts = 0
for pin in pinch3:
    # slow
    stage2_counts += count_paths(target_fft, [pin], 10) * count_paths([pin], target_dac, 10)
print('S2', stage2_counts)

stage3_counts = count_paths(target_dac, end)
print('S3', stage3_counts)

print("Part 2:", stage1_counts * stage2_counts * stage3_counts)
# P2:    377452269415704

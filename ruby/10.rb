#!/usr/bin/env ruby

def read_input
    input = File.open("../inputs/input10.txt", "r")
    lines = []
    input.each_line do |line|
        goal_buttons_joltages = line.chomp.split(" ")
        goal = goal_buttons_joltages[0].gsub(/[\[\]]/, "").split("").map{ |c| c == "#" }
        buttons = goal_buttons_joltages[1...-1].map{ |b| b.gsub(/[\(\)]/, "").split(",").map{ |d| d.to_i } }
        #p joltages = goal_buttons_joltages[-1].gsub(/[\[\]]/, "")
        lines.push [goal, buttons]
    end
    lines
end

lines = read_input()

# find shortest combination of given buttons which produces the goal state for each line
# need 0 or 1 copies of every button

total = 0
lines.each do |line|
    p "=== new line ==="
    goal, buttons = line
    numbutts = 1
    looping = true
    while looping do
        p "numbutts #{numbutts}"
        button_perms = buttons.permutation(numbutts).to_a
        button_perms.each do |perm|
            press_result_hash = perm.reduce(Hash.new(false)){ |acc, btn_effects|
                btn_effects.each{ |idx|
                    acc[idx] = !acc[idx]
                }
                acc
            }
            result_state = Array.new(goal.size).map.with_index{ |_, i| press_result_hash[i] }
            if result_state == goal
                p [perm, result_state, goal]
                total += numbutts
                looping = false # break while
                break # break each
            end
        end
        numbutts += 1
    end
end
p "Part 1: #{total}"

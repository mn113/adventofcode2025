#!/usr/bin/env ruby
require 'set'

@networkid = 0
@conns = {}
@edge_keys = Set.new
@edge_dists = []
@low_edge_dists = []
@last_edge = []

def read_input
    input = File.open("../inputs/input08.txt", "r")
    input.each_line do |line|
        xyz_arr = line.chomp.split(",").map(&:to_i)
        @conns[xyz_arr] = nil
    end
end

def sort(n1, n2)
    px, py, pz = n1
    qx, qy, qz = n2
    if "#{px}_#{py}_#{pz}" > "#{qx}_#{qy}_#{qz}"
        [n1, n2]
    else
        [n2, n1]
    end
end

def distance(n1, n2)
    px, py, pz = n1
    qx, qy, qz = n2
    Math.sqrt((px - qx) ** 2 + (py - qy) ** 2 + (pz - qz) ** 2)
end

def get_top3()
    top3 = (1..@networkid).to_a.map{ |nid|
      group = @conns.values.select{ |entry| entry == nid }
      group.size
    }.sort.reverse!.take(3)
end

read_input()

# compute & store all inter-node distances
for node1 in @conns.keys do
    for node2 in @conns.keys do
        next if node1 == node2

        n1, n2 = sort(node1, node2)
        edgekey = "#{n1}_#{n2}"
        next if @edge_keys.include? edgekey

        d = distance(n1, n2)

        @edge_keys.add(edgekey)
        @edge_dists.append([n1, n2, d])
        @low_edge_dists.append(d)
    end
end
p "#{@edge_dists.size} edge_dists"

# starting with shortest distance, tag nodes into networks
@low_edge_dists.sort().take(6000).each.with_index{ |d, i|
    edge = @edge_dists.find{ |entry| entry[2] == d }
    n1, n2 = edge.take(2)
    if @conns[n1].nil? and @conns[n2].nil?
        @networkid += 1
        @conns[n1] = @networkid
        @conns[n2] = @conns[n1]
        @last_edge = [n1, n2]
        # p "A) #{n1} and #{n2} marked as network #{@networkid}"
    elsif @conns[n1] == @conns[n2]
        # already connected
        next
    elsif @conns[n1].nil?
        @conns[n1] = @conns[n2]
        @last_edge = [n1, n2]
        # p "B) #{n1} and #{n2} marked as network #{@conns[n2]}"
    elsif @conns[n2].nil?
        @conns[n2] = @conns[n1]
        @last_edge = [n1, n2]
        # p "C) #{n2} and #{n1} marked as network #{@conns[n1]}"
    elsif @conns[n2] != @conns[n1]
        # both not nil: re-assign everything to the first networkid
        n1id = @conns[n1]
        n2id = @conns[n2]
        @conns.each{ |key, value| if value == n2id then @conns[key] = n1id end }
        @last_edge = [n1, n2]
        # p "D) reassigned nodes from network #{n2id} to #{n1id}"
    end
    # Multiply top 3 network sizes after connecting 1000 nodes
    if i == 1000
        p "Part 1: #{get_top3().reduce(:*)}"
    end

    # How many more nodes to connect beyond 1000, to get everything connected as one?
    # 1500 => 55 nets and nil
    # 2000 => 19 nets and nil
    # 2500 => 8 nets and nil
    # 3000 => 5 nets and nil
    # 3600 => 1 net and nil
    # 4135 => 1 net
    if i > 3000 and Set.new(@conns.values).size == 1
        p "#{Set.new(@conns.values).size} distinct networks at turn #{i}"
        x1 = @last_edge[0][0]
        x2 = @last_edge[1][0]
        p "Part 2: #{x1 * x2}"
        break
    end
}

# P1: 57564
# P2: 133296744

#!/usr/bin/env ruby
require 'set'

DOT = "."
TILE = "#"
EDGE_H = "="
EDGE_V = ":"
INNER = "o"

@tiles = Set.new
@conns_h = Set.new
@conns_v = Set.new
@conns = Set.new
@inners = Set.new

def read_input
    input = File.open("../inputs/input09.txt", "r")
    input.each_line do |line|
        xy_arr = line.chomp.split(",").map(&:to_i)
        @tiles.add(xy_arr)
    end
end

read_input()

minx = @tiles.map{ |x,y| x }.min
miny = @tiles.map{ |x,y| y }.min
maxx = @tiles.map{ |x,y| x }.max
maxy = @tiles.map{ |x,y| y }.max
midx = (minx + maxx) / 2
midy = 48794 #(miny + maxy) / 2

@top_left = @tiles.select{ |x,y| x < midx && y < midy }
@top_right = @tiles.select{ |x,y| x >= midx && y < midy }
@bottom_left = @tiles.select{ |x,y| x < midx && y >= midy }
@bottom_right = @tiles.select{ |x,y| x >= midx && y >= midy }

def rect_area(rect)
    x1, x2, y1, y2 = rect
    ((1 + x2 - x1) * (1 + y2 - y1)).abs
end

biggest_area = 0

@top_left.each do |x1, y1|
    @bottom_right.each do |x2, y2|
        area = rect_area([x1, x2, y1, y2])
        if area > biggest_area
            biggest_area = area
        end
    end
end
@top_right.each do |x1, y1|
    @bottom_left.each do |x2, y2|
        area = rect_area([x1, x2, y1, y2])
        if area > biggest_area
            biggest_area = area
        end
    end
end

p "Part 1: #{biggest_area}"
# P1: 4735222687



# connect tiles by adding all edges
@tiles.each_cons(2) do |pair|
  x1, y1 = pair[0]
  x2, y2 = pair[1]
  if x1 == x2
    lo_y, hi_y = [y1, y2].minmax
    # hi_y = [y1, y2].max
    while lo_y < hi_y do
        lo_y += 1
        hi_y -= 1
        @conns_v.add([x1, lo_y]) unless @tiles.include? [x1, lo_y]
        @conns_v.add([x1, hi_y]) unless @tiles.include? [x1, hi_y]
    end
  elsif y1 == y2
    lo_x, hi_x = [x1, x2].minmax
    # hi_x = [x1, x2].max
    while lo_x < hi_x do
        lo_x += 1
        hi_x -= 1
        @conns_h.add([lo_x, y1]) unless @tiles.include? [lo_x, y1]
        @conns_h.add([hi_x, y1]) unless @tiles.include? [hi_x, y1]
    end
  end
end

@uniq_x = @tiles.map{ |x,y| x }.uniq.sort
@uniq_y = @tiles.map{ |x,y| y }.uniq.sort
@conns = @conns_h.union(@conns_v)
@tiles_conns = @tiles.union(@conns)

def rect_contains?(rect, pt)
    rx1, rx2, ry1, ry2 = rect
    x, y = pt
    x >= rx1 and x <= rx2 and y >= ry1 and y <= ry2
end

# print tiles (246 lines)
def print_grid(rect)
    @uniq_y.each.with_index do |real_y, y|
        @uniq_x.each.with_index do |real_x, x|
            is_contained = rect_contains?(rect, [real_x, real_y])
            is_tile = @tiles.include? [real_x, real_y]
            is_conn_h = @conns_h.include? [real_x, real_y]
            is_conn_v = @conns_v.include? [real_x, real_y]
            is_conn = @conns.include? [real_x, real_y]
            is_inner = @inners.include? [real_x, real_y]
            if is_contained and is_tile
                print "R"
            elsif is_contained
                print "r"
            elsif is_tile
                print TILE
            elsif is_conn_h
                print EDGE_H
            elsif is_conn_v
                print EDGE_V
            elsif is_inner
                print INNER
            else
                print DOT
            end
        end
        print " #{y} #{real_y}\n"
    end
end
# filled area is a diamond, but with a slice missing between top and bottom halves

@nearest_xs = {}
@nearest_ys = {}

def find_nearest_xs(x)
    return @nearest_xs[x] if @nearest_xs.has_key? x
    id = @uniq_x.index(x)
    lower = @uniq_x[[id - 1, 0].max]
    higher = @uniq_x[[id + 1, @uniq_x.size - 1].min]
    @nearest_xs[x] = [lower, higher]
    [lower, higher]
end

def find_nearest_ys(y)
    return @nearest_ys[y] if @nearest_ys.has_key? y
    id = @uniq_y.index(y)
    lower = @uniq_y[[id - 1, 0].max]
    higher = @uniq_y[[id + 1, @uniq_y.size - 1].min]
    @nearest_ys[y] = [lower, higher]
    [lower, higher]
end

def flood_fill(from)
    to_see = [from]
    while to_see.size > 0 and @inners.size < 30000 do
        curr = to_see.shift
        @inners.add curr if !@tiles_conns.include? curr
        x, y = curr
        xlower, xhigher = find_nearest_xs(x)
        ylower, yhigher = find_nearest_ys(y)
        nbs = [[xlower, y], [xhigher, y], [x, ylower], [x, yhigher]]
        to_see.concat(nbs.reject{ |nb| @tiles_conns.include? nb or @inners.include? nb or to_see.include? nb })
    end
end

flood_fill([50002, 3003])

def within_shape?(pt)
    return true if @tiles_conns.include? pt
    return true if @inners.include? pt
    false
end

def rect_within_shape?(rect)
    rx1, rx2, ry1, ry2 = rect
    all_x = @uniq_x.filter{ |x| rx1 <= x and x <= rx2 }
    all_y = @uniq_y.filter{ |y| ry1 <= y and y <= ry2 }
    all_x.each{ |x|
        all_y.each{ |y|
            return false if !within_shape?([x, y])
        }
    }
    true
end

def find_largest_rects()
    # check every pair of nodes
    rects = []

    # top half
    @top_left.each{ |corner1|
        x1, y1 = corner1
        @top_right.each{ |corner4|
            x2, y2 = corner4
            rect = [x1, x2, y1, y2]
            area = rect_area(rect)
            if area > 1_500_000_000
                rects.push [area, corner1, corner4]
            end
        }
    }
    # bottom half
    @bottom_left.each{ |corner1|
        x1, y1 = corner1
        @bottom_right.each{ |corner4|
            x2, y2 = corner4
            rect = [x1, x2, y1, y2]
            area = rect_area(rect)
            if area > 1_500_000_000
                rects.push [area, corner1, corner4]
            end
        }
    }
    rects.sort!.reverse!
end
largest_rects = find_largest_rects()
p "#{largest_rects.size} candidates"

while 1 do
    area, corner1, corner4 = largest_rects.shift()
    x1, x2 = [corner1[0], corner4[0]].minmax
    y1, y2 = [corner1[1], corner4[1]].minmax
    rect = [x1, x2, y1, y2]
    if rect_within_shape?(rect)
        print_grid(rect)
        p rect
        p "Part 2: #{rect_area(rect)}"
        break
        # P2: 1569262188
    end
end

# "Count the number of times a depth measurement increases from the previous
# measurement. (There is no measurement before the first measurement.) "
def load_input()
  File.readlines("inputs/day_1.txt", chomp: true).map do |line|
    Integer(line)
  end
end

def part_1()
  depths = load_input()

  depths.zip(depths[1..]).select do |depth_1, depth_2|
    puts "#{depth_1} #{depth_2}"
    depth_2 != nil && depth_2 > depth_1
  end.count
end

puts part_1()

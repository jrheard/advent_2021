# typed: true

#extend T::sig

# "Count the number of times a depth measurement increases from the previous
# measurement. (There is no measurement before the first measurement.) "
#sig {params(env: T::Hash[Symbol, Integer], key: Symbol).void}
def load_input()
  File.readlines("inputs/day_1.txt", chomp: true).map do |line|
    Integer(line)
  end
end

def part_1()
  depths = load_input()

  depths.zip(depths[1..]).select do |depth_1, depth_2|
    depth_2 != nil && depth_2 > depth_1
  end.count
end

def part_2()
  depths = load_input()

  last_window_sum = depths[0..2].sum
  result = 0
  depths.each_cons(3).each do |window|
    if window.sum > last_window_sum
      result += 1
    end

    last_window_sum = window.sum
  end

  result


  # TODO can i do this with each_cons?
end

puts part_1()

puts part_2()

# typed: true

# "Count the number of times a depth measurement increases from the previous
# measurement. (There is no measurement before the first measurement.) "

# TODO: is this main class necessary???
class Main
  extend T::Sig

  sig { returns(T::Array[Integer]) }
  def load_input
    File.readlines('inputs/day_1.txt', chomp: true).map do |line|
      Integer(line)
    end
  end

  def part_one
    depths = load_input

    depths.zip(depths[1..]).select do |depth_1, depth_2|
      !depth_2.nil? && depth_2 > depth_1
    end.count
  end

  def part_two
    depths = load_input

    last_window_sum = depths[0..2].sum
    result = 0
    depths.each_cons(3).each do |window|
      result += 1 if window.sum > last_window_sum

      last_window_sum = window.sum
    end

    result

    # TODO: can i do this with each_cons?
  end
end

puts part_one

puts part_two

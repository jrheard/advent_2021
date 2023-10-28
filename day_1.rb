# typed: true

# TODO: is this main class necessary???
class Main
  extend T::Sig

  sig { returns(T::Array[Integer]) }
  def load_input
    File.readlines('inputs/day_1.txt', chomp: true).map do |line|
      Integer(line)
    end
  end

  # "Count the number of times a depth measurement increases from the previous
  # measurement. (There is no measurement before the first measurement.) "
  sig { returns(Integer) }
  def part_one
    depths = load_input

    depths.zip(T.must(depths[1..])).select do |depth_one, depth_two|
      !depth_two.nil? && depth_two > depth_one
    end.count
  end

  sig { returns(Integer) }
  def part_two
    depths = load_input

    last_window_sum = T.must(depths[0..2]).sum
    result = 0
    depths.each_cons(3).each do |window|
      result += 1 if window.sum > last_window_sum

      last_window_sum = window.sum
    end

    result

    # TODO: can i do this with each_cons?
  end
end

main = Main.new
puts main.part_one
puts main.part_two

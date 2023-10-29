# typed: strict

require 'sorbet-runtime'

module DayOne
  extend T::Sig

  sig { returns(T::Array[Integer]) }
  def self.load_input
    File.readlines('inputs/day_1.txt', chomp: true).map do |line|
      Integer(line)
    end
  end

  # "Count the number of times a depth measurement increases from the previous
  # measurement. (There is no measurement before the first measurement.) "
  sig { returns(Integer) }
  def self.part_one
    depths = load_input

    depths.zip(T.must(depths[1..])).count do |depth_one, depth_two|
      !depth_two.nil? && depth_two > depth_one
    end
  end

  # "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
  sig { returns(Integer) }
  def self.part_two
    depths = load_input

    window_sums = depths.each_cons(3).map(&:sum)

    window_sums.zip(T.must(window_sums[1..])).count do |window_one, window_two|
      !window_two.nil? && window_two > window_one
    end
  end
end

puts DayOne.part_one
puts DayOne.part_two

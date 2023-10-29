# typed: strict

require 'sorbet-runtime'

module DayFive
  extend T::Sig

  class OceanVent < T::Struct
    extend T::Sig

    const :start_x, Integer
    const :start_y, Integer
    const :end_x, Integer
    const :end_y, Integer

    sig { returns(T::Array[[Integer, Integer]]) }
    def range
      xs = @start_x < @end_x ? @start_x..@end_x : @end_x..@start_x
      ys = @start_y < @end_y ? @start_y..@end_y : @end_y..@start_y

      xs.to_a.product(ys.to_a)
    end
  end

  sig { returns(T::Array[OceanVent]) }
  def self.load_input
    File.readlines('inputs/day_5.txt', chomp: true).map do |line|
      start_x, start_y = line.split(' ').fetch(0).split(',').map { |num| Integer(num) }
      end_x, end_y = line.split(' ').fetch(2).split(',').map { |num| Integer(num) }
      OceanVent.new(start_x: T.must(start_x), start_y: T.must(start_y), end_x: T.must(end_x), end_y: T.must(end_y))
    end
  end

  sig { returns(Integer) }
  def self.part_one
    num_vents_by_position = T.let(Hash.new { 0 }, T::Hash[[Integer, Integer], Integer])

    load_input.select do |vent|
      # "For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2."
      vent.start_x == vent.end_x || vent.start_y == vent.end_y
    end.each do |vent|
      vent.range.each do |x, y|
        num_vents_by_position[[x, y]] = T.must(num_vents_by_position[[x, y]]) + 1
      end
    end

    num_vents_by_position.select { |_k, v| v > 1 }.count
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayFive.part_one
puts DayFive.part_two

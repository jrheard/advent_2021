# typed: strict

require 'sorbet-runtime'

module DayTwo
  extend T::Sig

  class Instruction < T::Struct
    const :direction, Symbol
    const :magnitude, Integer
  end

  sig { returns(T::Array[Instruction]) }
  def self.load_input
    File.readlines('inputs/day_2.txt', chomp: true).map do |line|
      # Lines look like "forward 5".
      Instruction.new(
        direction: T.must(line.split[0]).to_sym,
        magnitude: Integer(T.must(line.split[1]))
      )
    end
  end

  # "Calculate the horizontal position and depth you would have after following
  # the planned course. What do you get if you multiply your final horizontal
  # position by your final depth?"
  sig { returns(Integer) }
  def self.part_one
    x = 0
    y = 0
    load_input.each do |instruction|
      case instruction.direction
      when :forward
        x += instruction.magnitude
      when :down
        y += instruction.magnitude
      when :up
        y -= instruction.magnitude
      end
    end

    x * y
  end

  sig { returns(Integer) }
  def self.part_two
    x = 0
    y = 0
    aim = 0
    load_input.each do |instruction|
      case instruction.direction
      when :forward
        # "forward X does two things:
        # It increases your horizontal position by X units.
        # It increases your depth by your aim multiplied by X."

        x += instruction.magnitude
        y += instruction.magnitude * aim

      when :down
        aim += instruction.magnitude
      when :up
        aim -= instruction.magnitude
      end
    end

    # "What do you get if you multiply your final horizontal position by your final depth?"
    x * y
  end
end

puts DayTwo.part_one
puts DayTwo.part_two

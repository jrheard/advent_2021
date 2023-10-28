# typed: true

require 'sorbet-runtime'

module DayTwo
  extend T::Sig

  # A representation of an input line like `forward 5`.
  class Instruction
    extend T::Sig

    sig { returns(Symbol) }
    attr_reader :direction

    sig { returns(Integer) }
    attr_reader :magnitude

    sig { params(direction: Symbol, magnitude: Integer).void }
    def initialize(direction, magnitude)
      @direction = direction
      @magnitude = magnitude
    end

    sig { returns(String) }
    def to_s
      "#{direction} #{magnitude}"
    end
  end

  sig { returns(T::Array[Instruction]) }
  def self.load_input
    File.readlines('inputs/day_2.txt', chomp: true).map do |line|
      Instruction.new(
        T.must(line.split[0]).to_sym,
        Integer(T.must(line.split[1]))
      )
    end
  end

  # "Calculate the horizontal position and depth you would have after following
  # the planned course. What do you get if you multiply your final horizontal
  # position by your final depth?"
  sig { returns(Integer) }
  def self.part_one
    # TODO: rewrite without Instruction, just pattern matching on string.split
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
    -1
  end
end

puts DayTwo.part_one
puts DayTwo.part_two

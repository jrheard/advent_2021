# typed: true

require 'sorbet-runtime'

module DayFour
  extend T::Sig

  class Board
    extend T::Sig

    sig { returns(T::Array[Integer]) }
    attr_reader :contents

    sig { returns(T::Array[[Integer, Integer]]) }
    attr_reader :marked_positions

    sig { params(lines: T::Array[String]).void }
    def initialize(lines)
      raise unless lines.count == 5

      @contents = T.let(lines.join(' ').split(' ').reject(&:empty?).map do |num|
        Integer(num)
      end, T::Array[Integer])

      @marked_positions = T.let([], T::Array[[Integer, Integer]])
    end
  end

  sig { returns([T::Array[Integer], T::Array[Board]]) }
  def self.load_input
    lines = File.readlines('inputs/day_4.txt', chomp: true)

    [
      T.must(lines[0]).split(',').map do |num|
        Integer(num)
      end,
      T.must(lines[2..]).each_slice(6).map do |lines_slice|
        Board.new(T.must(lines_slice[0..4]))
      end
    ]
  end

  sig { returns(Integer) }
  def self.part_one
    load_input
    -1
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayFour.part_one
puts DayFour.part_two

# typed: strict

require 'sorbet-runtime'

module DayFour
  extend T::Sig

  # "Bingo is played on a set of boards each consisting of a 5x5 grid of numbers."
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

    sig { params(index: Integer).returns([Integer, Integer]) }
    def index_to_position(index)
      [
        index % 5,
        index / 5
      ]
    end

    # "Numbers are chosen at random, and the chosen number is marked on all
    # boards on which it appears. (Numbers may not appear on all boards.)"
    sig { params(num: Integer).void }
    def mark_number(num)
      index = @contents.index(num)
      return unless index

      @marked_positions << index_to_position(index)
    end

    # "If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)"
    sig { returns(T::Boolean) }
    def won?
      5.times do |i|
        return true if @marked_positions.select { |x, _y| x == i }.count == 5
        return true if @marked_positions.select { |_x, y| y == i }.count == 5
      end

      false
    end

    # "The score of the winning board can now be calculated. Start by finding
    # the sum of all unmarked numbers on that board. Then, multiply that sum by
    # the number that was just called when the board won to get the final score."
    sig { returns(T.nilable(Integer)) }
    def score
      return nil unless won?

      unmarked_numbers_sum = (0..24).reject do |i|
        @marked_positions.include?(index_to_position(i))
      end.map do |i|
        @contents.fetch(i)
      end.sum

      x, y = T.must(@marked_positions.last)

      unmarked_numbers_sum * @contents.fetch(y * 5 + x)
    end
  end

  sig { returns([T::Array[Integer], T::Array[Board]]) }
  def self.load_input
    lines = File.readlines('inputs/day_4.txt', chomp: true)

    [
      lines.fetch(0).split(',').map do |num|
        Integer(num)
      end,
      T.must(lines[2..]).each_slice(6).map do |lines_slice|
        Board.new(T.must(lines_slice[0..4]))
      end
    ]
  end

  # "To guarantee victory against the giant squid, figure out which board will
  # win first. What will your final score be if you choose that board?"
  sig { returns(Integer) }
  def self.part_one
    numbers_to_call, boards = load_input

    numbers_to_call.each do |number|
      boards.each do |board|
        board.mark_number(number)
        score = board.score
        return score if score
      end
    end

    -1
  end

  # "Figure out which board will win last. Once it wins, what would its final score be?"
  sig { returns(Integer) }
  def self.part_two
    numbers_to_call, boards = load_input

    numbers_to_call.each do |number|
      boards.each do |board|
        board.mark_number(number)
        next unless board.won?

        return T.must(board.score) if boards.count == 1

        boards = boards.reject { |b| board == b }
      end
    end

    -1
  end
end

puts DayFour.part_one
puts DayFour.part_two

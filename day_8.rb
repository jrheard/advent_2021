# typed: strict

require 'sorbet-runtime'

module DayEight
  extend T::Sig

  class NoteEntry < T::Struct
    extend T::Sig

    const :signal_patterns, T::Array[String]
    const :output_value, T::Array[String]
  end

  sig { returns(T::Array[NoteEntry]) }
  def self.load_input
    File.readlines('inputs/day_8.txt', chomp: true).map do |line|
      NoteEntry.new(
        signal_patterns: line.split(' | ').fetch(0).split(' '),
        output_value: line.split(' | ').fetch(1).split(' ')
      )
    end
  end

  sig { returns(Integer) }
  def self.part_one
    # "In the output values, how many times do digits 1, 4, 7, or 8 appear?"
    load_input.map do |entry|
      entry.output_value.select do |str|
        [2, 3, 4, 7].include?(str.length)
      end.count
    end.sum
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayEight.part_one
puts DayEight.part_two

# typed: strict

require 'sorbet-runtime'

module DaySeven
  extend T::Sig

  # thx stackoverflow
  sig { params(array: T::Array[Integer]).returns(Integer) }
  def self.median(array)
    raise if array.empty?

    sorted = array.sort
    len = sorted.length
    (sorted.fetch((len - 1) / 2) + sorted.fetch(len / 2)) / 2
  end

  sig { returns(T::Array[Integer]) }
  def self.load_input
    line = File.readlines('inputs/day_7.txt', chomp: true).fetch(0)
    line.split(',').map do |num|
      Integer(num)
    end
  end

  sig { returns(Integer) }
  def self.part_one
    crab_positions = load_input
    best_position = median(crab_positions)
    crab_positions.map do |position|
      (best_position - position).abs
    end.sum
  end

  sig { returns(Integer) }
  def self.part_two
    crab_positions = load_input
    best_position = (crab_positions.sum / crab_positions.size.to_f).floor
    crab_positions.map do |position|
      (0..(best_position - position).abs).sum
    end.sum
  end
end

puts DaySeven.part_one
puts DaySeven.part_two

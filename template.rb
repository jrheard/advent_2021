# typed: true

require 'sorbet-runtime'

module DayFoo
  extend T::Sig

  sig { returns(T::Array[String]) }
  def self.load_input
    File.readlines('inputs/day_2.txt', chomp: true)
  end

  sig { returns(Integer) }
  def self.part_one
    -1
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayFoo.part_one
puts DayFoo.part_two

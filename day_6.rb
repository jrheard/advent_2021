# typed: strict

require 'sorbet-runtime'

module DayFive
  extend T::Sig

  class LanternfishSchool
    extend T::Sig

    sig { returns(T::Array[Integer]) }
    attr_reader :buckets

    sig { params(initial_fish: T::Array[Integer]).void }
    def initialize(initial_fish)
      @buckets = T.let([0, 0, 0, 0, 0, 0, 0, 0, 0], T::Array[Integer])
      initial_fish.each do |i|
        @buckets[i] = @buckets.fetch(i) + 1
      end
    end

    sig { void }
    def iterate
      new_buckets = [0, 0, 0, 0, 0, 0, 0, 0, 0]

      (1..8).each do |i|
        new_buckets[i - 1] = @buckets.fetch(i)
      end

      new_buckets[6] = new_buckets.fetch(6) + @buckets.fetch(0)
      new_buckets[8] = @buckets.fetch(0)

      @buckets = new_buckets
    end
  end

  sig { returns(T::Array[Integer]) }
  def self.load_input
    line = File.readlines('inputs/day_6.txt', chomp: true).fetch(0)
    line.split(',').map do |s|
      Integer(s)
    end
  end

  sig { returns(Integer) }
  def self.part_one
    school = LanternfishSchool.new(load_input)

    80.times do
      school.iterate
    end

    school.buckets.sum
  end

  sig { returns(Integer) }
  def self.part_two
    school = LanternfishSchool.new(load_input)

    256.times do
      school.iterate
    end

    school.buckets.sum
  end
end

puts DayFive.part_one
puts DayFive.part_two

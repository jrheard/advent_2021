# typed: true

require 'sorbet-runtime'

module DayFoo
  extend T::Sig

  sig { void }
  def self.load_input
    -1
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

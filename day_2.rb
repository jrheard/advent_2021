# typed: true

require 'sorbet-runtime'

module DayTwo
  extend T::Sig

  sig { returns(T::Array[String]) }
  def self.load_input
    File.readlines('inputs/day_2.txt', chomp: true)
  end

  # "Calculate the horizontal position and depth you would have after following
  # the planned course. What do you get if you multiply your final horizontal
  # position by your final depth?"
  sig { returns(Integer) }
  def self.part_one
    x = 0
    y = 0
    load_input.each do |line|
      # Lines look like "forward 5".
      magnitude = Integer(T.must(line.split[1]))

      case T.must(line.split[0])
      when 'forward'
        x += magnitude
      when 'down'
        y += magnitude
      when 'up'
        y -= magnitude
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

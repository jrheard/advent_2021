# typed: true

require 'sorbet-runtime'
require 'pry'

module DayThree
  extend T::Sig

  sig { returns(T::Array[String]) }
  def self.load_input
    File.readlines('inputs/day_3.txt', chomp: true)
  end

  # "Each bit in the gamma rate can be determined by finding the most common bit
  # in the corresponding position of all numbers in the diagnostic report."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_gamma_rate(numbers)
    bits_per_number = T.must(numbers[0]).length

    (0..bits_per_number - 1).map do |i|
      tally = numbers.map do |number|
        number[i]
      end.tally

      T.must(tally.max_by { |_k, v| v })[0]
    end.join
  end

  # "The epsilon rate is calculated in a similar way; rather than use the most
  # common bit, the least common bit from each position is used."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_epsilon_rate(numbers)
    bits_per_number = T.must(numbers[0]).length

    (0..bits_per_number - 1).map do |i|
      tally = numbers.map do |number|
        number[i]
      end.tally

      T.must(tally.min_by { |_k, v| v })[0]
    end.join
  end

  sig { returns(Integer) }
  def self.part_one
    numbers = load_input
    gamma = find_gamma_rate(numbers).to_i(2)
    epsilon = find_epsilon_rate(numbers).to_i(2)

    gamma * epsilon
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayThree.part_one
puts DayThree.part_two

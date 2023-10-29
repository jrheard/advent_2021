# typed: strict

require 'sorbet-runtime'
require 'pry'

module DayThree
  extend T::Sig

  Tallies = T.type_alias { T::Array[T::Hash[T.nilable(String), Integer]] }

  sig { returns(T::Array[String]) }
  def self.load_input
    File.readlines('inputs/day_3.txt', chomp: true)
  end

  sig { params(numbers: T::Array[String]).returns(Tallies) }
  def self.tallies_by_position_for_numbers(numbers)
    bits_per_number = numbers.fetch(0).length

    (0..bits_per_number - 1).map do |i|
      numbers.map do |number|
        number[i]
      end.tally
    end
  end

  sig { params(tallies: Tallies, max_by_or_min_by: Symbol, default: T.nilable(String)).returns(String) }
  def self.choose_bit_per_position(tallies, max_by_or_min_by, default)
    raise unless %i[max_by min_by].include?(max_by_or_min_by)

    tallies.map do |tally|
      if default && tally['0'] == tally['1']
        default
      else
        T.let(tally.send(max_by_or_min_by) { |_k, v| v }, T::Array[String])[0]
      end
    end.join
  end

  # "Each bit in the gamma rate can be determined by finding the most common bit
  # in the corresponding position of all numbers in the diagnostic report."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_gamma_rate(numbers)
    choose_bit_per_position(tallies_by_position_for_numbers(numbers), :max_by, nil)
  end

  # "The epsilon rate is calculated in a similar way; rather than use the most
  # common bit, the least common bit from each position is used."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_epsilon_rate(numbers)
    choose_bit_per_position(tallies_by_position_for_numbers(numbers), :min_by, nil)
  end

  # "To find oxygen generator rating, determine the most common value (0 or 1)
  # in the current bit position, and keep only numbers with that bit in that
  # position. If 0 and 1 are equally common, keep values with a 1 in the
  # position being considered."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_oxygen_generator_rating(numbers)
    candidates = numbers
    bits_per_number = numbers.fetch(0).length

    (0..bits_per_number - 1).each do |i|
      ideal_number = choose_bit_per_position(tallies_by_position_for_numbers(candidates), :max_by, '1')
      candidates = candidates.select do |number|
        number[i] == ideal_number[i]
      end

      break if candidates.count == 1
    end

    candidates.fetch(0)
  end

  # "To find CO2 scrubber rating, determine the least common value (0 or 1) in
  # the current bit position, and keep only numbers with that bit in that
  # position. If 0 and 1 are equally common, keep values with a 0 in the
  # position being considered."
  sig { params(numbers: T::Array[String]).returns(String) }
  def self.find_co2_scrubber_rating(numbers)
    candidates = numbers
    bits_per_number = numbers.fetch(0).length

    (0..bits_per_number - 1).each do |i|
      ideal_number = choose_bit_per_position(tallies_by_position_for_numbers(candidates), :min_by, '0')
      candidates = candidates.select do |number|
        number[i] == ideal_number[i]
      end

      break if candidates.count == 1
    end

    candidates.fetch(0)
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
    numbers = load_input

    find_oxygen_generator_rating(numbers).to_i(2) * find_co2_scrubber_rating(numbers).to_i(2)
  end
end

puts DayThree.part_one
puts DayThree.part_two

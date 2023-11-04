# typed: strict

require 'sorbet-runtime'

module DayNine
  extend T::Sig

  class HeightMap < T::Struct
    extend T::Sig

    const :contents, T::Array[Integer]
    const :width, Integer
    const :height, Integer

    sig { params(x: Integer, y: Integer).returns(Integer) }
    def value_at(x, y)
      @contents.fetch(y * @width + x)
    end

    sig { params(x: Integer, y: Integer).returns(T::Enumerable[Integer]) }
    def neighbor_values(x, y)
      [
        [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1]
      ].select do |xx, yy|
        xx >= 0 && xx < @width && yy >= 0 && yy < @height
      end.map do |xx, yy|
        value_at(xx, yy)
      end
    end
  end

  sig { returns(HeightMap) }
  def self.load_input
    HeightMap.new(
      contents: File.readlines('inputs/day_9.txt', chomp: true).map do |line|
        line.each_char.map do |c|
          Integer(c)
        end
      end.flatten,
      width: File.readlines('inputs/day_9.txt', chomp: true).fetch(0).length,
      height: File.readlines('inputs/day_9.txt', chomp: true).count
    )
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

puts DayNine.part_one
puts DayNine.part_two

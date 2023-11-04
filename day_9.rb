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

    sig { returns(T::Array[T::Array[Integer]]) }
    def low_points
      # "Your first goal is to find the low points - the locations that are lower
      # than any of its adjacent locations. Most locations have four adjacent
      # locations (up, down, left, and right); locations on the edge or corner of
      # the map have three or two adjacent locations, respectively. (Diagonal
      # locations do not count as adjacent.)"
      (0..@height - 1).map do |y|
        (0..@width - 1).select do |x|
          position_value = value_at(x, y)
          neighbor_values(x, y).select do |neighbor_value|
            neighbor_value <= position_value
          end.count.zero?
        end.map do |x|
          [x, y]
        end
      end.flatten(1)
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
    height_map = load_input

    # "The risk level of a low point is 1 plus its height. In the above example,
    # the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk
    # levels of all low points in the heightmap is therefore 15."
    #
    # "Find all of the low points on your heightmap. What is the sum of the risk
    # levels of all low points on your heightmap?"
    height_map.low_points.map do |x, y|
      height_map.value_at(T.must(x), T.must(y)) + 1
    end.sum
  end

  sig { returns(Integer) }
  def self.part_two
    -1
  end
end

puts DayNine.part_one
puts DayNine.part_two

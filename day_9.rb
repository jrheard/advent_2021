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

    sig { params(x: Integer, y: Integer).returns(T::Array[T::Array[Integer]]) }
    def neighbor_positions(x, y)
      [
        [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1]
      ].select do |xx, yy|
        xx >= 0 && xx < @width && yy >= 0 && yy < @height
      end
    end

    sig { params(x: Integer, y: Integer).returns(T::Enumerable[Integer]) }
    def neighbor_values(x, y)
      neighbor_positions(x, y).map do |xx, yy|
        value_at(T.must(xx), T.must(yy))
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

    # "A basin is all locations that eventually flow downward to a single low
    # point. Therefore, every low point has a basin, although some basins are
    # very small. Locations of height 9 do not count as being in any basin,
    # and all other locations will always be part of exactly one basin."
    sig { params(x: Integer, y: Integer).returns(T::Set[T::Array[Integer]]) }
    def find_basin_from_starting_point(x, y)
      basin = Set.new([[x, y]])
      unseen_positions = T.let(Set.new(neighbor_positions(x, y)), T::Set[T::Array[Integer]])

      until unseen_positions.empty?
        position = T.must(unseen_positions.first)
        unseen_positions.delete(position)

        xx = position.fetch(0)
        yy = position.fetch(1)
        next unless value_at(xx, yy) != 9

        basin.add(position)

        neighbor_positions(xx, yy).select do |neighbor_position|
          !basin.include?(neighbor_position) && !unseen_positions.include?(neighbor_position)
        end.each do |neighbor_position|
          unseen_positions.add(neighbor_position)
        end
      end

      basin
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
    height_map = load_input

    basins = height_map.low_points.map do |x, y|
      height_map.find_basin_from_starting_point(T.must(x), T.must(y))
    end

    # "Find the three largest basins and multiply their sizes together."
    T.let(T.must(basins.map(&:count).sort.reverse[0..2]).reduce(:*), Integer)
  end
end

puts DayNine.part_one
puts DayNine.part_two

defmodule Mazes.RectangularMazeTest do
  use ExUnit.Case
  alias Mazes.RectangularMaze

  describe "new" do
    test "generates an adjacency matrix with no adjacent cells" do
      adjacency_row = %{
        {1, 1} => false,
        {1, 2} => false,
        {1, 3} => false,
        {2, 1} => false,
        {2, 2} => false,
        {2, 3} => false
      }

      assert RectangularMaze.new(2, 3) === %RectangularMaze{
               width: 2,
               height: 3,
               adjacency_matrix: %{
                 {1, 1} => Map.delete(adjacency_row, {1, 1}),
                 {1, 2} => Map.delete(adjacency_row, {1, 2}),
                 {1, 3} => Map.delete(adjacency_row, {1, 3}),
                 {2, 1} => Map.delete(adjacency_row, {2, 1}),
                 {2, 2} => Map.delete(adjacency_row, {2, 2}),
                 {2, 3} => Map.delete(adjacency_row, {2, 3})
               }
             }
    end
  end

  describe "outer_wall?" do
    test "checks if there is the outer wall between two cells" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.outer_wall?(maze, {1, 1}, {0, 1}) == true
      assert RectangularMaze.outer_wall?(maze, {1, 2}, {0, 2}) == true
      assert RectangularMaze.outer_wall?(maze, {1, 3}, {0, 3}) == true

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {2, 1}) == false
      assert RectangularMaze.outer_wall?(maze, {1, 2}, {2, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {1, 3}, {2, 3}) == false

      assert RectangularMaze.outer_wall?(maze, {2, 1}, {3, 1}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 2}, {3, 2}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {3, 3}) == true

      assert RectangularMaze.outer_wall?(maze, {2, 1}, {1, 1}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 2}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {1, 3}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 1}, {2, 2}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {1, 0}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 1}, {2, 0}) == true

      assert RectangularMaze.outer_wall?(maze, {1, 3}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {2, 2}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 3}, {1, 4}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {2, 4}) == true
    end
  end

  describe "wall?" do
    test "outer wall counts as a wall" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.wall?(maze, {1, 1}, {0, 1}) == true
      assert RectangularMaze.wall?(maze, {1, 2}, {0, 2}) == true
      assert RectangularMaze.wall?(maze, {1, 3}, {0, 3}) == true

      assert RectangularMaze.wall?(maze, {2, 1}, {3, 1}) == true
      assert RectangularMaze.wall?(maze, {2, 2}, {3, 2}) == true
      assert RectangularMaze.wall?(maze, {2, 3}, {3, 3}) == true

      assert RectangularMaze.wall?(maze, {1, 1}, {1, 0}) == true
      assert RectangularMaze.wall?(maze, {2, 1}, {2, 0}) == true

      assert RectangularMaze.wall?(maze, {1, 3}, {1, 4}) == true
      assert RectangularMaze.wall?(maze, {2, 3}, {2, 4}) == true
    end

    test "checks if there's a wall between two cells" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == true
      maze = RectangularMaze.remove_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == false
      maze = RectangularMaze.put_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == true
    end
  end
end

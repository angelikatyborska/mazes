defmodule Mazes.RectangularMazeDistancesTest do
  use ExUnit.Case
  alias Mazes.RectangularMaze
  alias Mazes.RectangularMazeDistances

  describe "calculate" do
    test "when all walls" do
      maze = RectangularMaze.new(2, 3, false)

      result = RectangularMazeDistances.calculate(maze, {1, 1})

      assert result == %{
               {1, 1} => 0
             }
    end

    test "when no walls" do
      maze = RectangularMaze.new(2, 3, true)

      result = RectangularMazeDistances.calculate(maze, {1, 1})

      assert result == %{
               {1, 1} => 0,
               {1, 2} => 1,
               {1, 3} => 2,
               {2, 1} => 1,
               {2, 2} => 2,
               {2, 3} => 3
             }

      result = RectangularMazeDistances.calculate(maze, {2, 2})

      assert result == %{
               {1, 1} => 2,
               {1, 2} => 1,
               {1, 3} => 2,
               {2, 1} => 1,
               {2, 2} => 0,
               {2, 3} => 1
             }
    end

    test "when some walls" do
      maze = RectangularMaze.new(2, 3, true)
      maze = RectangularMaze.put_wall(maze, {2, 1}, {2, 2})

      result = RectangularMazeDistances.calculate(maze, {2, 2})

      assert result == %{
               {1, 1} => 2,
               {1, 2} => 1,
               {1, 3} => 2,
               {2, 1} => 3,
               {2, 2} => 0,
               {2, 3} => 1
             }
    end
  end
end

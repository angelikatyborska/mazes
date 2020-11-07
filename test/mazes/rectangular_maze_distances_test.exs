defmodule Mazes.RectangularMazeDistancesTest do
  use ExUnit.Case
  alias Mazes.RectangularMaze
  alias Mazes.RectangularMazeDistances

  describe "path" do
    test "when all walls" do
      maze = RectangularMaze.new(2, 3, false)
      result = RectangularMazeDistances.shortest_path(maze, {1, 1}, {2, 2})
      assert result == nil
    end

    test "when no walls" do
      maze = RectangularMaze.new(2, 3, true)
      result = RectangularMazeDistances.shortest_path(maze, {1, 1}, {2, 3})
      assert result == [{1, 1}, {1, 2}, {1, 3}, {2, 3}]
    end

    test "when some walls" do
      maze =
        RectangularMaze.new(3, 3, true)
        |> RectangularMaze.put_wall({1, 1}, {2, 1})
        |> RectangularMaze.put_wall({2, 1}, {2, 2})
        |> RectangularMaze.put_wall({2, 3}, {3, 3})

      result = RectangularMazeDistances.shortest_path(maze, {1, 1}, {3, 3})
      assert result == [{1, 1}, {1, 2}, {2, 2}, {3, 2}, {3, 3}]
    end

    test "when some walls but no path" do
      maze =
        RectangularMaze.new(3, 3, true)
        |> RectangularMaze.put_wall({1, 1}, {1, 2})
        |> RectangularMaze.put_wall({2, 1}, {2, 2})
        |> RectangularMaze.put_wall({3, 1}, {3, 2})

      result = RectangularMazeDistances.shortest_path(maze, {1, 1}, {3, 3})
      assert result == nil
    end
  end

  describe "find_max_vertex_by_distance" do
    test "when no walls" do
      maze = RectangularMaze.new(2, 3, true)

      result = RectangularMazeDistances.find_max_vertex_by_distance(maze, {2, 2})
      assert result == {{1, 1}, 2}
    end

    test "when some walls" do
      maze = RectangularMaze.new(2, 3, true)
      maze = RectangularMaze.put_wall(maze, {2, 1}, {2, 2})

      result = RectangularMazeDistances.find_max_vertex_by_distance(maze, {2, 2})
      assert result == {{2, 1}, 3}
    end
  end

  describe "distances" do
    test "when all walls" do
      maze = RectangularMaze.new(2, 3, false)

      result = RectangularMazeDistances.distances(maze, {1, 1})

      assert result == %{
               {1, 1} => 0
             }
    end

    test "when no walls" do
      maze = RectangularMaze.new(2, 3, true)

      result = RectangularMazeDistances.distances(maze, {1, 1})

      assert result == %{
               {1, 1} => 0,
               {1, 2} => 1,
               {1, 3} => 2,
               {2, 1} => 1,
               {2, 2} => 2,
               {2, 3} => 3
             }

      result = RectangularMazeDistances.distances(maze, {2, 2})

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

      result = RectangularMazeDistances.distances(maze, {2, 2})

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

defmodule Mazes.MazeDistancesTest do
  use ExUnit.Case
  alias Mazes.{RectangularMaze, Maze, MazeDistances}

  describe "path" do
    test "when all walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: false)
      result = MazeDistances.shortest_path(maze, {1, 1}, {2, 2})
      assert result == nil
    end

    test "when no walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true)
      result = MazeDistances.shortest_path(maze, {1, 1}, {2, 3})
      assert result == [{1, 1}, {2, 1}, {2, 2}, {2, 3}]
    end

    test "when some walls" do
      maze =
        RectangularMaze.new(width: 3, height: 3, all_vertices_adjacent?: true)
        |> Maze.put_wall({1, 1}, {2, 1})
        |> Maze.put_wall({2, 1}, {2, 2})
        |> Maze.put_wall({2, 3}, {3, 3})

      result = MazeDistances.shortest_path(maze, {1, 1}, {3, 3})
      assert result == [{1, 1}, {1, 2}, {2, 2}, {3, 2}, {3, 3}]
    end

    test "when some walls but no path" do
      maze =
        RectangularMaze.new(width: 3, height: 3, all_vertices_adjacent?: true)
        |> Maze.put_wall({1, 1}, {1, 2})
        |> Maze.put_wall({2, 1}, {2, 2})
        |> Maze.put_wall({3, 1}, {3, 2})

      result = MazeDistances.shortest_path(maze, {1, 1}, {3, 3})
      assert result == nil
    end
  end

  describe "find_max_vertex_by_distance" do
    test "when no walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true)

      result = MazeDistances.find_max_vertex_by_distance(maze, {2, 2})
      assert result == {{1, 1}, 2}
    end

    test "when some walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true)
      maze = Maze.put_wall(maze, {2, 1}, {2, 2})

      result = MazeDistances.find_max_vertex_by_distance(maze, {2, 2})
      assert result == {{2, 1}, 3}
    end
  end

  describe "distances" do
    test "when all walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: false)

      result = MazeDistances.distances(maze, {1, 1})

      assert result == %{
               {1, 1} => 0
             }
    end

    test "when no walls" do
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true)

      result = MazeDistances.distances(maze, {1, 1})

      assert result == %{
               {1, 1} => 0,
               {1, 2} => 1,
               {1, 3} => 2,
               {2, 1} => 1,
               {2, 2} => 2,
               {2, 3} => 3
             }

      result = MazeDistances.distances(maze, {2, 2})

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
      maze = RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true)
      maze = Maze.put_wall(maze, {2, 1}, {2, 2})

      result = MazeDistances.distances(maze, {2, 2})

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

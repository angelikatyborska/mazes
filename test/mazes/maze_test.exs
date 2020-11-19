defmodule Mazes.MazeTest do
  use ExUnit.Case
  alias Mazes.{Maze, RectangularMaze}

  describe "vertices" do
    test "returns sorted from left to right, top to bottom" do
      maze = RectangularMaze.new(width: 4, height: 4)

      assert Maze.vertices(maze) == [
               {1, 1},
               {2, 1},
               {3, 1},
               {4, 1},
               {1, 2},
               {2, 2},
               {3, 2},
               {4, 2},
               {1, 3},
               {2, 3},
               {3, 3},
               {4, 3},
               {1, 4},
               {2, 4},
               {3, 4},
               {4, 4}
             ]
    end
  end

  describe "wall?" do
    test "outer wall counts as a wall" do
      maze = RectangularMaze.new(width: 2, height: 3)
      assert Maze.wall?(maze, {1, 1}, {0, 1}) == true
      assert Maze.wall?(maze, {1, 2}, {0, 2}) == true
      assert Maze.wall?(maze, {1, 3}, {0, 3}) == true

      assert Maze.wall?(maze, {2, 1}, {3, 1}) == true
      assert Maze.wall?(maze, {2, 2}, {3, 2}) == true
      assert Maze.wall?(maze, {2, 3}, {3, 3}) == true

      assert Maze.wall?(maze, {1, 1}, {1, 0}) == true
      assert Maze.wall?(maze, {2, 1}, {2, 0}) == true

      assert Maze.wall?(maze, {1, 3}, {1, 4}) == true
      assert Maze.wall?(maze, {2, 3}, {2, 4}) == true
    end

    test "checks if there's a wall between two vertices" do
      maze = RectangularMaze.new(width: 2, height: 3)
      assert Maze.wall?(maze, {1, 3}, {2, 3}) == true
      maze = Maze.remove_wall(maze, {1, 3}, {2, 3})
      assert Maze.wall?(maze, {1, 3}, {2, 3}) == false
      maze = Maze.put_wall(maze, {1, 3}, {2, 3})
      assert Maze.wall?(maze, {1, 3}, {2, 3}) == true
    end
  end

  describe "adjacent_vertices" do
    test "returns direct neighbors not separated by a wall" do
      maze = RectangularMaze.new(width: 2, height: 3)
      assert Maze.adjacent_vertices(maze, {1, 3}) == []
      maze = Maze.remove_wall(maze, {1, 3}, {2, 3})
      assert Maze.adjacent_vertices(maze, {1, 3}) == [{2, 3}]
      maze = Maze.remove_wall(maze, {1, 3}, {1, 2})
      assert Maze.adjacent_vertices(maze, {1, 3}) == [{1, 2}, {2, 3}]
      maze = Maze.put_wall(maze, {1, 3}, {2, 3})
      assert Maze.adjacent_vertices(maze, {1, 3}) == [{1, 2}]
    end

    test "when no walls" do
      maze = RectangularMaze.new(width: 3, height: 3, all_vertices_adjacent?: true)
      assert Maze.adjacent_vertices(maze, {1, 1}) == [{2, 1}, {1, 2}]
      assert Maze.adjacent_vertices(maze, {2, 2}) == [{2, 1}, {1, 2}, {3, 2}, {2, 3}]
      assert Maze.adjacent_vertices(maze, {3, 3}) == [{3, 2}, {2, 3}]
    end
  end

  describe "group_vertices_by_adjacent_count" do
    test "returns a map with lists of vertices" do
      maze =
        RectangularMaze.new(width: 3, height: 3, all_vertices_adjacent?: true)
        |> Maze.put_wall({1, 1}, {1, 2})
        |> Maze.put_wall({2, 1}, {2, 2})
        |> Maze.put_wall({1, 2}, {1, 3})
        |> Maze.put_wall({2, 2}, {2, 3})

      assert Maze.group_vertices_by_adjacent_count(maze) ==
               %{
                 1 => [{1, 1}, {1, 2}, {1, 3}],
                 2 => [{2, 1}, {3, 1}, {2, 2}, {2, 3}, {3, 3}],
                 3 => [{3, 2}]
               }
    end
  end
end

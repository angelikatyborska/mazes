defmodule Mazes.MazeGeneration.WilsonsAlgorithmTest do
  alias Mazes.MazeGeneration.WilsonsAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert WilsonsAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = WilsonsAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(WilsonsAlgorithm.supported_maze_types(), fn module ->
      case module do
        m when m in [Mazes.RectangularMaze, Mazes.RectangularMazeWithMask] ->
          maze = WilsonsAlgorithm.generate([width: 10, height: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.TriangularMaze ->
          maze = WilsonsAlgorithm.generate([side_length: 10], module)
          assert MazeDistances.shortest_path(maze, {6, 9}, {15, 8})

        Mazes.CircularMaze ->
          maze = WilsonsAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.HexagonalMaze ->
          maze = WilsonsAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {10, 1}, {10, 10})
      end
    end)
  end
end

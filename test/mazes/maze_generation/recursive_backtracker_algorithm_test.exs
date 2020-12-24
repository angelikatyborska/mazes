defmodule Mazes.MazeGeneration.RecursiveBacktrackerAlgorithmTest do
  alias Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert RecursiveBacktrackerAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = RecursiveBacktrackerAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(RecursiveBacktrackerAlgorithm.supported_maze_types(), fn module ->
      case module do
        m when m in [Mazes.RectangularMaze, Mazes.RectangularMazeWithMask] ->
          maze = RecursiveBacktrackerAlgorithm.generate([width: 10, height: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.TriangularMaze ->
          maze = RecursiveBacktrackerAlgorithm.generate([width: 10, height: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.CircularMaze ->
          maze = RecursiveBacktrackerAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.HexagonalMaze ->
          maze = RecursiveBacktrackerAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {10, 1}, {10, 10})
      end
    end)
  end
end

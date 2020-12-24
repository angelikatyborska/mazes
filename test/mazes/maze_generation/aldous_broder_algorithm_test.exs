defmodule Mazes.MazeGeneration.AldousBroderAlgorithmTest do
  alias Mazes.MazeGeneration.AldousBroderAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert AldousBroderAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = AldousBroderAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  # TODO: refactor as a macro? do not pass all options to all maze types...
  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(AldousBroderAlgorithm.supported_maze_types(), fn module ->
      case module do
        m when m in [Mazes.RectangularMaze, Mazes.RectangularMazeWithMask] ->
          maze = AldousBroderAlgorithm.generate([width: 10, height: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.TriangularMaze ->
          maze = AldousBroderAlgorithm.generate([width: 10, height: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.CircularMaze ->
          maze = AldousBroderAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})

        Mazes.HexagonalMaze ->
          maze = AldousBroderAlgorithm.generate([radius: 10], module)
          assert MazeDistances.shortest_path(maze, {10, 1}, {10, 10})
      end
    end)
  end
end

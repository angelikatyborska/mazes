defmodule Mazes.MazeGeneration.RecursiveBacktrackerAlgorithmTest do
  alias Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert RecursiveBacktrackerAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = RecursiveBacktrackerAlgorithm.generate(10, 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end

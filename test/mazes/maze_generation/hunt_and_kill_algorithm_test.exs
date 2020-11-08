defmodule Mazes.MazeGeneration.HuntAndKillAlgorithmTest do
  alias Mazes.MazeGeneration.HuntAndKillAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert HuntAndKillAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = HuntAndKillAlgorithm.generate(10, 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end

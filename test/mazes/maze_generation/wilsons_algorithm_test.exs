defmodule Mazes.MazeGeneration.WilsonsAlgorithmTest do
  alias Mazes.MazeGeneration.WilsonsAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert WilsonsAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = WilsonsAlgorithm.generate(10, 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end

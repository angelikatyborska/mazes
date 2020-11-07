defmodule Mazes.MazeGeneration.BinaryTreeAlgorithmTest do
  alias Mazes.MazeGeneration.BinaryTreeAlgorithm
  alias Mazes.RectangularMazeDistances

  use ExUnit.Case

  test "finishes" do
    assert BinaryTreeAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = BinaryTreeAlgorithm.generate(10, 10)
    assert RectangularMazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end

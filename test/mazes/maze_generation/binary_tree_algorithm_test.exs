defmodule Mazes.MazeGeneration.BinaryTreeAlgorithmTest do
  alias Mazes.MazeGeneration.BinaryTreeAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert BinaryTreeAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = BinaryTreeAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(BinaryTreeAlgorithm.supported_maze_types(), fn module ->
      maze = BinaryTreeAlgorithm.generate([width: 10, height: 10, radius: 10], module)
      assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
    end)
  end
end

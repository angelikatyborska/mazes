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
      maze = WilsonsAlgorithm.generate([width: 10, height: 10], module)
      assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
    end)
  end
end

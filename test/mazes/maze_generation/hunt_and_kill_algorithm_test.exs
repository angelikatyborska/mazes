defmodule Mazes.MazeGeneration.HuntAndKillAlgorithmTest do
  alias Mazes.MazeGeneration.HuntAndKillAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert HuntAndKillAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = HuntAndKillAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(HuntAndKillAlgorithm.supported_maze_types(), fn module ->
      maze = HuntAndKillAlgorithm.generate([width: 10, height: 10, radius: 10], module)
      assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
    end)
  end
end

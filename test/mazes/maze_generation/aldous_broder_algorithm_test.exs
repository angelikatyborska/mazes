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

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(AldousBroderAlgorithm.supported_maze_types(), fn module ->
      maze = AldousBroderAlgorithm.generate([width: 10, height: 10], module)
      assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
    end)
  end
end

defmodule Mazes.MazeGeneration.SidewinderAlgorithmTest do
  alias Mazes.MazeGeneration.SidewinderAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert SidewinderAlgorithm.generate(width: 3, height: 3)
  end

  test "produces a maze that can be solved" do
    maze = SidewinderAlgorithm.generate(width: 10, height: 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end

  test "produces a maze that can be solved for all maze types it supports" do
    Enum.each(SidewinderAlgorithm.supported_maze_types(), fn module ->
      maze = SidewinderAlgorithm.generate([width: 10, height: 10, rings: 10], module)
      assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
    end)
  end
end

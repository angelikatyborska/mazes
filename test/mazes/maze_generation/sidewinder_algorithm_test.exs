defmodule Mazes.MazeGeneration.SidewinderAlgorithmTest do
  alias Mazes.MazeGeneration.SidewinderAlgorithm
  alias Mazes.RectangularMazeDistances

  use ExUnit.Case

  test "finishes" do
    assert SidewinderAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = SidewinderAlgorithm.generate(10, 10)
    assert RectangularMazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end

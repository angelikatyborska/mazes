defmodule Mazes.TriangularMazeTest do
  use ExUnit.Case
  alias Mazes.TriangularMaze

  describe "new" do
    test "sets a correct adjacency matrix" do
      result = TriangularMaze.new(width: 4, height: 3)
      assert result.width == 4
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 1} => %{{1, 2} => false, {2, 1} => false},
               {1, 2} => %{{1, 1} => false, {2, 2} => false},
               {1, 3} => %{{2, 3} => false},
               {2, 1} => %{{1, 1} => false, {3, 1} => false},
               {2, 2} => %{{1, 2} => false, {2, 3} => false, {3, 2} => false},
               {2, 3} => %{{1, 3} => false, {2, 2} => false, {3, 3} => false},
               {3, 1} => %{{2, 1} => false, {3, 2} => false, {4, 1} => false},
               {3, 2} => %{{2, 2} => false, {3, 1} => false, {4, 2} => false},
               {3, 3} => %{{2, 3} => false, {4, 3} => false},
               {4, 1} => %{{3, 1} => false},
               {4, 2} => %{{3, 2} => false, {4, 3} => false},
               {4, 3} => %{{3, 3} => false, {4, 2} => false}
             }
    end
  end

  describe "center" do
    test "odd size" do
      maze = TriangularMaze.new(width: 5, height: 5)
      assert TriangularMaze.center(maze) == {3, 3}
    end

    test "even size" do
      maze = TriangularMaze.new(width: 4, height: 4)
      assert TriangularMaze.center(maze) == {2, 2}
    end
  end
end

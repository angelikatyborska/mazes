defmodule Mazes.TriangularMazeTest do
  use ExUnit.Case
  alias Mazes.TriangularMaze

  describe "new" do
    test "sets a correct adjacency matrix" do
      result = TriangularMaze.new(side_length: 3)
      assert result.width == 5
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 3} => %{{2, 3} => false},
               {2, 2} => %{{2, 3} => false, {3, 2} => false},
               {2, 3} => %{{1, 3} => false, {2, 2} => false, {3, 3} => false},
               {3, 1} => %{{3, 2} => false},
               {3, 2} => %{{2, 2} => false, {3, 1} => false, {4, 2} => false},
               {3, 3} => %{{2, 3} => false, {4, 3} => false},
               {4, 2} => %{{3, 2} => false, {4, 3} => false},
               {4, 3} => %{{3, 3} => false, {4, 2} => false, {5, 3} => false},
               {5, 3} => %{{4, 3} => false}
             }
    end
  end

  describe "center" do
    test "odd size" do
      maze = TriangularMaze.new(side_length: 5)
      assert TriangularMaze.center(maze) == {5, 3}
    end

    test "even size" do
      maze = TriangularMaze.new(side_length: 4)
      assert TriangularMaze.center(maze) == {5, 2}
    end
  end
end

defmodule Mazes.HexagonalMazeTest do
  use ExUnit.Case
  alias Mazes.HexagonalMaze

  describe "new" do
    test "sets a correct adjacency matrix" do
      result = HexagonalMaze.new(width: 4, height: 3)
      assert result.width == 4
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 1} => %{
                 {2, 1} => false,
                 {1, 2} => false
               },
               {2, 1} => %{
                 {1, 1} => false,
                 {3, 1} => false,
                 {1, 2} => false,
                 {2, 2} => false,
                 {3, 2} => false
               },
               {3, 1} => %{
                 {2, 1} => false,
                 {4, 1} => false,
                 {3, 2} => false
               },
               {4, 1} => %{
                 {3, 1} => false,
                 {3, 2} => false,
                 {4, 2} => false
               },
               {1, 2} => %{
                 {1, 1} => false,
                 {2, 1} => false,
                 {2, 2} => false,
                 {1, 3} => false
               },
               {2, 2} => %{
                 {2, 1} => false,
                 {1, 2} => false,
                 {3, 2} => false,
                 {1, 3} => false,
                 {2, 3} => false,
                 {3, 3} => false
               },
               {3, 2} => %{
                 {2, 1} => false,
                 {3, 1} => false,
                 {4, 1} => false,
                 {2, 2} => false,
                 {4, 2} => false,
                 {3, 3} => false
               },
               {4, 2} => %{
                 {4, 1} => false,
                 {3, 2} => false,
                 {3, 3} => false,
                 {4, 3} => false
               },
               {1, 3} => %{
                 {1, 2} => false,
                 {2, 2} => false,
                 {2, 3} => false
               },
               {2, 3} => %{
                 {2, 2} => false,
                 {1, 3} => false,
                 {3, 3} => false
               },
               {3, 3} => %{
                 {2, 2} => false,
                 {3, 2} => false,
                 {4, 2} => false,
                 {2, 3} => false,
                 {4, 3} => false
               },
               {4, 3} => %{
                 {4, 2} => false,
                 {3, 3} => false
               }
             }
    end
  end

  test "north" do
    assert HexagonalMaze.north({1, 1}) == {1, 0}
    assert HexagonalMaze.north({1, 2}) == {1, 1}
    assert HexagonalMaze.north({1, 3}) == {1, 2}

    assert HexagonalMaze.north({2, 1}) == {2, 0}
    assert HexagonalMaze.north({2, 2}) == {2, 1}
    assert HexagonalMaze.north({2, 3}) == {2, 2}
  end

  test "south" do
    assert HexagonalMaze.south({1, 1}) == {1, 2}
    assert HexagonalMaze.south({1, 2}) == {1, 3}
    assert HexagonalMaze.south({1, 3}) == {1, 4}

    assert HexagonalMaze.south({2, 1}) == {2, 2}
    assert HexagonalMaze.south({2, 2}) == {2, 3}
    assert HexagonalMaze.south({2, 3}) == {2, 4}
  end

  test "northeast" do
    assert HexagonalMaze.northeast({1, 1}) == {2, 0}
    assert HexagonalMaze.northeast({1, 2}) == {2, 1}
    assert HexagonalMaze.northeast({1, 3}) == {2, 2}

    assert HexagonalMaze.northeast({2, 1}) == {3, 1}
    assert HexagonalMaze.northeast({2, 2}) == {3, 2}
    assert HexagonalMaze.northeast({2, 3}) == {3, 3}
  end

  test "northwest" do
    assert HexagonalMaze.northwest({1, 1}) == {0, 0}
    assert HexagonalMaze.northwest({1, 2}) == {0, 1}
    assert HexagonalMaze.northwest({1, 3}) == {0, 2}

    assert HexagonalMaze.northwest({2, 1}) == {1, 1}
    assert HexagonalMaze.northwest({2, 2}) == {1, 2}
    assert HexagonalMaze.northwest({2, 3}) == {1, 3}
  end

  test "southeast" do
    assert HexagonalMaze.southeast({1, 1}) == {2, 1}
    assert HexagonalMaze.southeast({1, 2}) == {2, 2}
    assert HexagonalMaze.southeast({1, 3}) == {2, 3}

    assert HexagonalMaze.southeast({2, 1}) == {3, 2}
    assert HexagonalMaze.southeast({2, 2}) == {3, 3}
    assert HexagonalMaze.southeast({2, 3}) == {3, 4}
  end

  test "southwest" do
    assert HexagonalMaze.southwest({1, 1}) == {0, 1}
    assert HexagonalMaze.southwest({1, 2}) == {0, 2}
    assert HexagonalMaze.southwest({1, 3}) == {0, 3}

    assert HexagonalMaze.southwest({2, 1}) == {1, 2}
    assert HexagonalMaze.southwest({2, 2}) == {1, 3}
    assert HexagonalMaze.southwest({2, 3}) == {1, 4}
  end
end

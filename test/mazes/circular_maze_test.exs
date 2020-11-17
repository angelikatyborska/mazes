defmodule Mazes.CircularMazeTest do
  use ExUnit.Case
  alias Mazes.CircularMaze

  describe "new" do
    test "xxx" do
      result = CircularMaze.new(rings: 4)
      assert result.width == 4
      assert result.height == 4

      assert result.adjacency_matrix == %{
               {1, 1} => %{
                 {1, 2} => false,
                 {2, 2} => false,
                 {3, 2} => false,
                 {4, 2} => false,
                 {5, 2} => false,
                 {6, 2} => false,
                 {7, 2} => false,
                 {8, 2} => false
               },
               {1, 2} => %{
                 {1, 1} => false,
                 {1, 3} => false,
                 {2, 2} => false,
                 {2, 3} => false,
                 {8, 2} => false
               },
               {1, 3} => %{
                 {1, 2} => false,
                 {1, 4} => false,
                 {2, 3} => false,
                 {16, 3} => false
               },
               {1, 4} => %{{1, 3} => false, {2, 4} => false, {16, 4} => false},
               {2, 2} => %{
                 {1, 1} => false,
                 {1, 2} => false,
                 {3, 2} => false,
                 {3, 3} => false,
                 {4, 3} => false
               },
               {2, 3} => %{
                 {1, 3} => false,
                 {3, 3} => false,
                 {1, 2} => false,
                 {2, 4} => false
               },
               {2, 4} => %{{1, 4} => false, {3, 4} => false, {2, 3} => false},
               {3, 2} => %{
                 {1, 1} => false,
                 {2, 2} => false,
                 {4, 2} => false,
                 {5, 3} => false,
                 {6, 3} => false
               },
               {3, 3} => %{
                 {2, 3} => false,
                 {4, 3} => false,
                 {2, 2} => false,
                 {3, 4} => false
               },
               {3, 4} => %{{2, 4} => false, {4, 4} => false, {3, 3} => false},
               {4, 2} => %{
                 {1, 1} => false,
                 {3, 2} => false,
                 {5, 2} => false,
                 {7, 3} => false,
                 {8, 3} => false
               },
               {4, 3} => %{
                 {3, 3} => false,
                 {5, 3} => false,
                 {2, 2} => false,
                 {4, 4} => false
               },
               {4, 4} => %{{3, 4} => false, {5, 4} => false, {4, 3} => false},
               {5, 2} => %{
                 {1, 1} => false,
                 {4, 2} => false,
                 {6, 2} => false,
                 {9, 3} => false,
                 {10, 3} => false
               },
               {5, 3} => %{
                 {4, 3} => false,
                 {6, 3} => false,
                 {3, 2} => false,
                 {5, 4} => false
               },
               {5, 4} => %{{4, 4} => false, {6, 4} => false, {5, 3} => false},
               {6, 2} => %{
                 {1, 1} => false,
                 {5, 2} => false,
                 {7, 2} => false,
                 {11, 3} => false,
                 {12, 3} => false
               },
               {6, 3} => %{
                 {5, 3} => false,
                 {3, 2} => false,
                 {6, 4} => false,
                 {7, 3} => false
               },
               {6, 4} => %{{5, 4} => false, {7, 4} => false, {6, 3} => false},
               {7, 4} => %{{6, 4} => false, {8, 4} => false, {7, 3} => false},
               {8, 4} => %{{7, 4} => false, {9, 4} => false, {8, 3} => false},
               {9, 4} => %{{8, 4} => false, {10, 4} => false, {9, 3} => false},
               {10, 4} => %{{9, 4} => false, {11, 4} => false, {10, 3} => false},
               {11, 4} => %{{10, 4} => false, {12, 4} => false, {11, 3} => false},
               {12, 4} => %{{11, 4} => false, {12, 3} => false, {13, 4} => false},
               {7, 2} => %{
                 {1, 1} => false,
                 {6, 2} => false,
                 {8, 2} => false,
                 {13, 3} => false,
                 {14, 3} => false
               },
               {7, 3} => %{{4, 2} => false, {6, 3} => false, {7, 4} => false, {8, 3} => false},
               {8, 2} => %{
                 {1, 1} => false,
                 {1, 2} => false,
                 {7, 2} => false,
                 {15, 3} => false,
                 {16, 3} => false
               },
               {8, 3} => %{{4, 2} => false, {7, 3} => false, {8, 4} => false, {9, 3} => false},
               {9, 3} => %{{5, 2} => false, {8, 3} => false, {9, 4} => false, {10, 3} => false},
               {10, 3} => %{{5, 2} => false, {9, 3} => false, {10, 4} => false, {11, 3} => false},
               {11, 3} => %{{6, 2} => false, {10, 3} => false, {11, 4} => false, {12, 3} => false},
               {12, 3} => %{{6, 2} => false, {11, 3} => false, {12, 4} => false, {13, 3} => false},
               {13, 3} => %{{7, 2} => false, {12, 3} => false, {13, 4} => false, {14, 3} => false},
               {13, 4} => %{{12, 4} => false, {13, 3} => false, {14, 4} => false},
               {14, 3} => %{{7, 2} => false, {13, 3} => false, {14, 4} => false, {15, 3} => false},
               {14, 4} => %{{13, 4} => false, {14, 3} => false, {15, 4} => false},
               {15, 3} => %{{8, 2} => false, {14, 3} => false, {15, 4} => false, {16, 3} => false},
               {15, 4} => %{{14, 4} => false, {15, 3} => false, {16, 4} => false},
               {16, 3} => %{{1, 3} => false, {8, 2} => false, {15, 3} => false, {16, 4} => false},
               {16, 4} => %{{1, 4} => false, {15, 4} => false, {16, 3} => false}
             }
    end
  end
end

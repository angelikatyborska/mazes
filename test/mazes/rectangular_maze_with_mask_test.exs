defmodule Mazes.RectangularMazeWithMaskTest do
  use ExUnit.Case
  alias Mazes.RectangularMazeWithMask

  describe "new" do
    test "no mask - generates an adjacency matrix with no adjacent vertices" do
      result = RectangularMazeWithMask.new(width: 2, height: 3)
      assert result.width == 2
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 1} => %{
                 {1, 2} => false,
                 {2, 1} => false
               },
               {1, 2} => %{
                 {1, 1} => false,
                 {1, 3} => false,
                 {2, 2} => false
               },
               {1, 3} => %{
                 {1, 2} => false,
                 {2, 3} => false
               },
               {2, 1} => %{
                 {1, 1} => false,
                 {2, 2} => false
               },
               {2, 2} => %{
                 {1, 2} => false,
                 {2, 1} => false,
                 {2, 3} => false
               },
               {2, 3} => %{
                 {1, 3} => false,
                 {2, 2} => false
               }
             }
    end

    test "no mask - generates an adjacency matrix with all vertices adjacent" do
      assert RectangularMazeWithMask.new(width: 2, height: 3, all_vertices_adjacent?: true).adjacency_matrix ==
               %{
                 {1, 1} => %{
                   {1, 2} => true,
                   {2, 1} => true
                 },
                 {1, 2} => %{
                   {1, 1} => true,
                   {1, 3} => true,
                   {2, 2} => true
                 },
                 {1, 3} => %{
                   {1, 2} => true,
                   {2, 3} => true
                 },
                 {2, 1} => %{
                   {1, 1} => true,
                   {2, 2} => true
                 },
                 {2, 2} => %{
                   {1, 2} => true,
                   {2, 1} => true,
                   {2, 3} => true
                 },
                 {2, 3} => %{
                   {1, 3} => true,
                   {2, 2} => true
                 }
               }
    end

    test "with mask - generates an adjacency matrix with no adjacent vertices" do
      result = RectangularMazeWithMask.new(width: 3, height: 3, mask_vertices: [{1, 1}, {3, 3}])
      assert result.width == 3
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 2} => %{
                 {1, 3} => false,
                 {2, 2} => false
               },
               {1, 3} => %{
                 {1, 2} => false,
                 {2, 3} => false
               },
               {2, 1} => %{
                 {2, 2} => false,
                 {3, 1} => false
               },
               {2, 2} => %{
                 {1, 2} => false,
                 {2, 1} => false,
                 {2, 3} => false,
                 {3, 2} => false
               },
               {2, 3} => %{
                 {1, 3} => false,
                 {2, 2} => false
               },
               {3, 1} => %{
                 {2, 1} => false,
                 {3, 2} => false
               },
               {3, 2} => %{
                 {2, 2} => false,
                 {3, 1} => false
               }
             }
    end
  end

  describe "vertices" do
    test "with a mask" do
      maze = RectangularMazeWithMask.new(width: 3, height: 3, mask_vertices: [{1, 1}, {3, 3}])

      assert RectangularMazeWithMask.vertices(maze) == [
               {2, 1},
               {3, 1},
               {1, 2},
               {2, 2},
               {3, 2},
               {1, 3},
               {2, 3}
             ]
    end
  end

  describe "adjacent_vertices" do
    test "with a mask" do
      maze =
        RectangularMazeWithMask.new(
          width: 3,
          height: 3,
          all_vertices_adjacent?: true,
          mask_vertices: [{1, 1}, {3, 3}]
        )

      assert RectangularMazeWithMask.adjacent_vertices(maze, {2, 1}) == [{3, 1}, {2, 2}]

      assert RectangularMazeWithMask.adjacent_vertices(maze, {2, 2}) == [
               {2, 1},
               {1, 2},
               {3, 2},
               {2, 3}
             ]
    end
  end

  describe "center" do
    test "when real center is in the maze" do
      maze =
        RectangularMazeWithMask.new(
          width: 5,
          height: 5,
          all_vertices_adjacent?: true,
          mask_vertices: [{1, 1}, {5, 5}]
        )

      assert RectangularMazeWithMask.center(maze) == {3, 3}
    end

    test "when real center is not in the maze" do
      #      maze = RectangularMazeWithMask.new(
      #        width: 5,
      #        height: 5,
      #        all_vertices_adjacent?: true,
      #        mask_vertices: [{3, 3}]
      #      )
      #
      #      assert RectangularMazeWithMask.center(maze) == {3, 2}

      maze =
        RectangularMazeWithMask.new(
          width: 5,
          height: 5,
          all_vertices_adjacent?: false,
          mask_vertices: [{3, 3}, {3, 4}, {3, 2}, {2, 3}, {4, 3}, {4, 2}]
        )

      assert RectangularMazeWithMask.center(maze) == {2, 2}
    end
  end
end

defmodule MazesWeb.PageViewTest do
  use MazesWeb.ConnCase, async: true

  alias MazesWeb.PageView
  alias Mazes.RectangularMaze

  describe "vertex_fill" do
    test "white vertex by default" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = %{maze | from: {1, 1}, to: {5, 5}}

      assert PageView.vertex_fill(maze, {1, 2}, [], false, %{}, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {5, 4}, [], false, %{}, false, 123) ==
               "style=\"fill: white\""
    end

    test "from and to" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = %{maze | from: {1, 1}, to: {5, 5}}

      assert PageView.vertex_fill(maze, {1, 1}, [], false, %{}, false, 123) ==
               "style=\"fill: lightgray\""

      assert PageView.vertex_fill(maze, {5, 5}, [], false, %{}, false, 123) ==
               "style=\"fill: gray\""
    end

    test "with colors" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = %{maze | from: {1, 1}, to: {5, 5}}
      colors = %{distances: %{{1, 2} => 1, {5, 4} => 10}, max_distance: 20}

      assert PageView.vertex_fill(maze, {1, 2}, [], false, colors, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {5, 4}, [], false, colors, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {1, 2}, [], false, colors, true, 123) ==
               "style=\"fill: hsl(123, 80%, 96%)\""

      assert PageView.vertex_fill(maze, {5, 4}, [], false, colors, true, 123) ==
               "style=\"fill: hsl(123, 80%, 55%)\""
    end

    test "when part of solution" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = %{maze | from: {1, 1}, to: {5, 5}}
      colors = %{distances: %{{1, 2} => 1, {5, 4} => 10}, max_distance: 20}
      solution = [{1, 1}, {1, 2}, {5, 5}]

      assert PageView.vertex_fill(maze, {1, 1}, solution, false, colors, false, 123) ==
               "style=\"fill: lightgray\""

      assert PageView.vertex_fill(maze, {1, 2}, solution, false, colors, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {5, 4}, solution, false, colors, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {5, 5}, solution, false, colors, false, 123) ==
               "style=\"fill: gray\""

      assert PageView.vertex_fill(maze, {1, 1}, solution, false, colors, true, 123) ==
               "style=\"fill: lightgray\""

      assert PageView.vertex_fill(maze, {1, 2}, solution, false, colors, true, 123) ==
               "style=\"fill: hsl(123, 80%, 96%)\""

      assert PageView.vertex_fill(maze, {5, 4}, solution, false, colors, true, 123) ==
               "style=\"fill: hsl(123, 80%, 55%)\""

      assert PageView.vertex_fill(maze, {5, 5}, solution, false, colors, true, 123) ==
               "style=\"fill: gray\""

      assert PageView.vertex_fill(maze, {1, 1}, solution, true, colors, true, 123) ==
               "style=\"fill: lightgray\""

      assert PageView.vertex_fill(maze, {1, 2}, solution, true, colors, true, 123) ==
               "style=\"fill: hsl(303, 80%, 50%)\""

      assert PageView.vertex_fill(maze, {5, 4}, solution, true, colors, true, 123) ==
               "style=\"fill: hsl(123, 80%, 55%)\""

      assert PageView.vertex_fill(maze, {5, 5}, solution, true, colors, true, 123) ==
               "style=\"fill: gray\""
    end
  end
end

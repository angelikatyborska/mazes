defmodule MazesWeb.PageViewTest do
  use MazesWeb.ConnCase, async: true

  alias MazesWeb.PageView
  alias Mazes.RectangularMaze

  describe "vertex_fill" do
    test "white vertex by default" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})

      assert PageView.vertex_fill(maze, {1, 2}, [], false, %{}, false, 123) ==
               "style=\"fill: white\""

      assert PageView.vertex_fill(maze, {5, 4}, [], false, %{}, false, 123) ==
               "style=\"fill: white\""
    end

    test "from and to" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})

      assert PageView.vertex_fill(maze, {1, 1}, [], false, %{}, false, 123) ==
               "style=\"fill: lightgray\""

      assert PageView.vertex_fill(maze, {5, 5}, [], false, %{}, false, 123) ==
               "style=\"fill: gray\""
    end

    test "with colors" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})
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
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})
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

  describe "PageView.move_coordinate_by_radius_and_angle" do
    @delta 0.0001
    test "no angle" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, 0)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, 0)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 200, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({123, 123}, 1, 0)
      assert_in_delta(x, 123, @delta)
      assert_in_delta(y, 122, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({100, 200}, 10, 0)
      assert_in_delta(x, 100, @delta)
      assert_in_delta(y, 190, @delta)
    end

    test "90deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 0.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 0.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "180deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 500, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 600, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
    end

    test "270deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.5)
      assert_in_delta(x, 300, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 1.5)
      assert_in_delta(x, 200, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 1.5)
      assert_in_delta(x, 200, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "360deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 200, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, -100, @delta)
    end

    test "450deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 2.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 2.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 2.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "-270deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * -1.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * -1.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * -1.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "45deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.25)
      assert_in_delta(x, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "135deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.75)
      assert_in_delta(x, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "225deg" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.25)
      assert_in_delta(x, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "325" do
      {x, y} = PageView.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.75)
      assert_in_delta(x, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
    end
  end
end

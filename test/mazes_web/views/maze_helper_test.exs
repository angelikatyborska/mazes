defmodule MazesWeb.MazeHelperTest do
  use MazesWeb.ConnCase, async: true

  alias MazesWeb.MazeHelper
  alias Mazes.RectangularMaze

  describe "vertex_color" do
    test "white vertex by default" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})

      assert MazeHelper.vertex_color(maze, {1, 2}, %{}, false, 123, 50) ==
               "white"

      assert MazeHelper.vertex_color(maze, {5, 4}, %{}, false, 123, 50) ==
               "white"
    end

    test "from and to" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})

      assert MazeHelper.vertex_color(maze, {1, 1}, %{}, false, 123, 50) ==
               "lightgray"

      assert MazeHelper.vertex_color(maze, {5, 5}, %{}, false, 123, 50) ==
               "gray"
    end

    test "with colors" do
      maze = RectangularMaze.new(height: 5, width: 5)
      maze = Map.merge(maze, %{from: {1, 1}, to: {5, 5}})
      colors = %{distances: %{{1, 2} => 1, {5, 4} => 10}, max_distance: 20}

      assert MazeHelper.vertex_color(maze, {1, 2}, colors, false, 123, 60) ==
               "white"

      assert MazeHelper.vertex_color(maze, {5, 4}, colors, false, 123, 60) ==
               "white"

      assert MazeHelper.vertex_color(maze, {1, 2}, colors, true, 123, 60) ==
               "hsl(123, 60%, 96%)"

      assert MazeHelper.vertex_color(maze, {5, 4}, colors, true, 123, 70) ==
               "hsl(123, 70%, 60%)"
    end
  end

  describe "MazeHelper.move_coordinate_by_radius_and_angle" do
    @delta 0.0001
    test "no angle" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, 0)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, 0)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 200, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({123, 123}, 1, 0)
      assert_in_delta(x, 123, @delta)
      assert_in_delta(y, 122, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({100, 200}, 10, 0)
      assert_in_delta(x, 100, @delta)
      assert_in_delta(y, 190, @delta)
    end

    test "90deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 0.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 0.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "180deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 500, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 600, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 1)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
    end

    test "270deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.5)
      assert_in_delta(x, 300, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 1.5)
      assert_in_delta(x, 200, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 1.5)
      assert_in_delta(x, 200, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "360deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 300, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, 200, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 2)
      assert_in_delta(x, 400, @delta)
      assert_in_delta(y, -100, @delta)
    end

    test "450deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 2.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * 2.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * 2.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "-270deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * -1.5)
      assert_in_delta(x, 500, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 200, :math.pi() * -1.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 400, @delta)
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 100}, 200, :math.pi() * -1.5)
      assert_in_delta(x, 600, @delta)
      assert_in_delta(y, 100, @delta)
    end

    test "45deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.25)
      assert_in_delta(x, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "135deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 0.75)
      assert_in_delta(x, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "225deg" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.25)
      assert_in_delta(x, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 + 100 * :math.pow(2, 0.5) / 2, @delta)
    end

    test "325" do
      {x, y} = MazeHelper.move_coordinate_by_radius_and_angle({400, 400}, 100, :math.pi() * 1.75)
      assert_in_delta(x, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
      assert_in_delta(y, 400 - 100 * :math.pow(2, 0.5) / 2, @delta)
    end
  end
end

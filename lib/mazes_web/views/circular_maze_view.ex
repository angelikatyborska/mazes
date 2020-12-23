defmodule MazesWeb.CircularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper

  def maze_radius(maze) do
    trunc(max_svg_width() / maze.radius) * maze.radius
  end

  def maze_center(maze) do
    center_x = svg_padding() + maze_radius(maze)
    center_y = svg_padding() + maze_radius(maze)
    {center_x, center_y}
  end

  def maze_vertex_points(maze, column_count, ring, current_column) do
    center = maze_center(maze)
    radius_delta = trunc(maze_radius(maze) / maze.radius)

    angle_steps = column_count
    angle_delta = 2 * :math.pi() / angle_steps

    start_angle = (current_column - 1) * angle_delta
    end_angle = current_column * angle_delta

    outer_arc_radius = ring * radius_delta
    inner_arc_radius = (ring - 1) * radius_delta

    %{
      outer_arc_radius: outer_arc_radius,
      outer_arc_start: move_coordinate_by_radius_and_angle(center, outer_arc_radius, start_angle),
      outer_arc_end: move_coordinate_by_radius_and_angle(center, outer_arc_radius, end_angle),
      inner_arc_radius: inner_arc_radius,
      inner_arc_start: move_coordinate_by_radius_and_angle(center, inner_arc_radius, start_angle),
      inner_arc_end: move_coordinate_by_radius_and_angle(center, inner_arc_radius, end_angle)
    }
  end
end

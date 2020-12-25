defmodule MazesWeb.CircularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.CircularMaze

  def svg_width(maze) do
    2 * (svg_padding() + maze_radius(maze))
  end

  def maze_radius(maze) do
    max_width = max_svg_width() - 2 * svg_padding()
    trunc(max_width / (2 * maze.radius)) * maze.radius
  end

  def ring_width(maze) do
    maze_radius(maze) / maze.radius
  end

  def maze_center(maze) do
    center_x = svg_padding() + maze_radius(maze)
    center_y = svg_padding() + maze_radius(maze)
    {center_x, center_y}
  end

  def vertex_center(maze, {_, 1}), do: maze_center(maze)

  def vertex_center(maze, {current_column, ring} = _vertex) do
    column_count =
      Enum.find(CircularMaze.rings(maze), fn %{ring: r} -> r == ring end).column_count

    center = maze_center(maze)
    radius_delta = trunc(maze_radius(maze) / maze.radius)

    angle_steps = column_count
    angle_delta = 2 * :math.pi() / angle_steps

    start_angle = (current_column - 1) * angle_delta
    end_angle = current_column * angle_delta

    outer_arc_radius = ring * radius_delta
    inner_arc_radius = (ring - 1) * radius_delta

    move_coordinate_by_radius_and_angle(
      center,
      (outer_arc_radius + inner_arc_radius) / 2,
      (start_angle + end_angle) / 2
    )
  end

  def center_vertex(maze, vertex, settings, colors) do
    {cx, cy} = maze_center(maze)

    content_tag(:circle, "",
      cx: cx,
      cy: cy,
      r: ring_width(maze),
      style:
        "fill: #{
          vertex_color(
            maze,
            vertex,
            colors,
            settings.show_colors,
            settings.hue,
            settings.saturation
          )
        }"
    )
  end

  def vertex(maze, {current_column, ring} = vertex, column_count, settings, colors) do
    %{
      outer_arc_radius: outer_radius,
      outer_arc_start: {outer_start_x, outer_start_y},
      outer_arc_end: {outer_end_x, outer_end_y},
      inner_arc_radius: inner_radius,
      inner_arc_start: {inner_start_x, inner_start_y},
      inner_arc_end: {inner_end_x, inner_end_y}
    } = maze_vertex_points(maze, column_count, ring, current_column)

    d =
      "M #{outer_start_x} #{outer_start_y}" <>
        " A #{outer_radius} #{outer_radius} 0 0 1 #{outer_end_x} #{outer_end_y}" <>
        " L #{inner_end_x} #{inner_end_y}" <>
        " A #{inner_radius} #{inner_radius} 0 0 0 #{inner_start_x} #{inner_start_y}" <>
        " L #{outer_start_x} #{outer_start_y}"

    content_tag(:path, "",
      d: d,
      stroke:
        vertex_color(
          maze,
          vertex,
          colors,
          settings.show_colors,
          settings.hue,
          settings.saturation
        ),
      style:
        "fill: #{
          vertex_color(
            maze,
            vertex,
            colors,
            settings.show_colors,
            settings.hue,
            settings.saturation
          )
        }"
    )
  end

  def inner_wall(maze, {current_column, ring} = _vertex, column_count) do
    %{
      inner_arc_radius: inner_radius,
      inner_arc_start: {inner_start_x, inner_start_y},
      inner_arc_end: {inner_end_x, inner_end_y}
    } = maze_vertex_points(maze, column_count, ring, current_column)

    d =
      "M #{inner_end_x} #{inner_end_y}" <>
        " A #{inner_radius} #{inner_radius} 0 0 0 #{inner_start_x} #{inner_start_y}"

    content_tag(:path, "",
      d: d,
      fill: "transparent",
      style: line_style(maze)
    )
  end

  def outer_wall(maze, {current_column, ring} = _vertex, column_count) do
    %{
      outer_arc_radius: outer_radius,
      outer_arc_start: {outer_start_x, outer_start_y},
      outer_arc_end: {outer_end_x, outer_end_y}
    } = maze_vertex_points(maze, column_count, ring, current_column)

    d =
      "M #{outer_end_x} #{outer_end_y}" <>
        " A #{outer_radius} #{outer_radius} 0 0 0 #{outer_start_x} #{outer_start_y}"

    content_tag(:path, "",
      d: d,
      fill: "transparent",
      style: line_style(maze)
    )
  end

  def cw_wall(maze, {current_column, ring} = _vertex, column_count) do
    %{
      outer_arc_end: {outer_end_x, outer_end_y},
      inner_arc_end: {inner_end_x, inner_end_y}
    } = maze_vertex_points(maze, column_count, ring, current_column)

    d =
      "M #{outer_end_x} #{outer_end_y}" <>
        " L #{inner_end_x} #{inner_end_y}"

    content_tag(:path, "",
      d: d,
      fill: "transparent",
      style: line_style(maze)
    )
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

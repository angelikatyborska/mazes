defmodule MazesWeb.TriangularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.{Maze, TriangularMaze}

  def triangle_base(maze) do
    max_width = max_svg_width() - 2 * svg_padding()
    max_height = max_svg_width() - 2 * svg_padding()
    a1 = trunc(max_width / maze.height)
    a2 = 2 * trunc(max_height / maze.height) / :math.sqrt(3)
    Enum.min([a1, a2])
  end

  def triangle_height(maze) do
    triangle_base(maze) * :math.sqrt(3) / 2
  end

  def svg_width(maze) do
    2 * svg_padding() + triangle_base(maze) * maze.height
  end

  def svg_height(maze) do
    2 * svg_padding() + triangle_height(maze) * maze.height
  end

  def triangle_center(maze, {x, y} = _vertex) do
    {x, y} =
      if TriangularMaze.base_down?({x, y}) do
        x = svg_padding() + triangle_base(maze) * x / 2
        y = svg_padding() + triangle_height(maze) * (y - 1 / 3)
        {x, y}
      else
        x = svg_padding() + triangle_base(maze) * x / 2
        y = svg_padding() + triangle_height(maze) * (y - 2 / 3)
        {x, y}
      end

    x_offset = if Integer.mod(maze.height, 2) == 1, do: 0, else: -triangle_base(maze) / 2
    {x + x_offset, y}
  end

  def triangle(maze, {x, y} = vertex, settings, colors) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    x_offset = if Integer.mod(maze.height, 2) == 1, do: x_offset, else: x_offset - a / 2
    y_offset = svg_padding()

    d =
      if TriangularMaze.base_down?(vertex) do
        "M #{format_number(x_offset + a * (trunc((x - 1) / 2) + 0.5))} #{
          format_number(y_offset + h * (y - 1))
        }" <>
          " l #{format_number(a / 2)} #{format_number(h)}" <>
          " l #{format_number(-a)} #{0}" <>
          " l #{format_number(a / 2)} #{format_number(-h)}"
      else
        "M #{format_number(x_offset + a * (trunc(x / 2) - 0.5))} #{
          format_number(y_offset + h * (y - 1))
        }" <>
          " l #{format_number(a)} #{0}" <>
          " l #{format_number(-a / 2)} #{format_number(h)}" <>
          " l #{format_number(-a / 2)} #{format_number(-h)}"
      end

    content_tag(:path, "",
      d: d,
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
        }",
      stroke:
        vertex_color(
          maze,
          vertex,
          colors,
          settings.show_colors,
          settings.hue,
          settings.saturation
        )
    )
  end

  def north_wall(maze, vertex) do
    a = triangle_base(maze)

    if TriangularMaze.base_down?(vertex) do
      nil
    else
      {left_x, left_y} = base_up_triangle_left(maze, vertex)

      d = "M #{format_number(left_x)} #{format_number(left_y)} l #{format_number(a)} #{0}"
      content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
    end
  end

  def south_wall(maze, vertex) do
    a = triangle_base(maze)
    h = triangle_height(maze)

    if TriangularMaze.base_down?(vertex) do
      {top_x, top_y} = base_down_triangle_top(maze, vertex)

      d =
        "M #{format_number(top_x - a / 2)} #{format_number(top_y + h)} l #{format_number(a)} #{0}"

      content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
    else
      nil
    end
  end

  def west_wall(maze, vertex) do
    a = triangle_base(maze)
    h = triangle_height(maze)

    d =
      if TriangularMaze.base_down?(vertex) do
        {top_x, top_y} = base_down_triangle_top(maze, vertex)

        "M #{format_number(top_x)} #{format_number(top_y)} l #{format_number(-a / 2)} #{
          format_number(h)
        }"
      else
        {left_x, left_y} = base_up_triangle_left(maze, vertex)

        "M #{format_number(left_x)} #{format_number(left_y)} l #{format_number(a / 2)} #{
          format_number(h)
        }"
      end

    content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
  end

  def east_wall(maze, vertex) do
    a = triangle_base(maze)
    h = triangle_height(maze)

    d =
      if TriangularMaze.base_down?(vertex) do
        {top_x, top_y} = base_down_triangle_top(maze, vertex)

        "M #{format_number(top_x)} #{format_number(top_y)} l #{format_number(a / 2)} #{
          format_number(h)
        }"
      else
        {left_x, left_y} = base_up_triangle_left(maze, vertex)

        "M #{format_number(left_x + a)} #{format_number(left_y)} l #{format_number(-a / 2)} #{
          format_number(h)
        }"
      end

    content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
  end

  defp base_down_triangle_top(maze, {x, y}) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    x_offset = if Integer.mod(maze.height, 2) == 1, do: x_offset, else: x_offset - a / 2
    y_offset = svg_padding()
    top_x = x_offset + a * (trunc((x - 1) / 2) + 0.5)
    top_y = y_offset + h * (y - 1)
    {top_x, top_y}
  end

  defp base_up_triangle_left(maze, {x, y}) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    x_offset = if Integer.mod(maze.height, 2) == 1, do: x_offset, else: x_offset - a / 2
    y_offset = svg_padding()
    left_x = x_offset + a * (trunc(x / 2) - 0.5)
    left_y = y_offset + h * (y - 1)
    {left_x, left_y}
  end
end

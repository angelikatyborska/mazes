defmodule MazesWeb.TriangularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.{Maze, TriangularMaze}

  def triangle_base(maze) do
    max_width = max_svg_width() - 2 * svg_padding()
    max_height = max_svg_width() - 2 * svg_padding()
    a1 = trunc(max_width / (1 + maze.width / 2))
    a2 = 2 * trunc(max_height / maze.height) / :math.sqrt(3)
    Enum.min([a1, a2])
  end

  def triangle_height(maze) do
    triangle_base(maze) * :math.sqrt(3) / 2
  end

  def svg_width(maze) do
    2 * svg_padding() + triangle_base(maze) * (1 + maze.width / 2)
  end

  def svg_height(maze) do
    2 * svg_padding() + triangle_height(maze) * maze.height
  end

  def triangle_center(maze, {x, y} = _vertex) do
    if TriangularMaze.base_down?({x, y}) do
      x = svg_padding() + triangle_base(maze) * x / 2
      y = svg_padding() + triangle_height(maze) * (y - 1 / 3)
      {x, y}
    else
      x = svg_padding() + triangle_base(maze) * x / 2
      y = svg_padding() + triangle_height(maze) * (y - 2 / 3)
      {x, y}
    end
  end

  def triangle(maze, {x, y} = vertex, settings, colors) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    y_offset = svg_padding()

    d =
      if TriangularMaze.base_down?(vertex) do
        "M #{x_offset + a * (trunc((x - 1) / 2) + 0.5)} #{y_offset + h * (y - 1)}" <>
          " l #{a / 2} #{h}" <>
          " l #{-a} #{0}" <>
          " l #{a / 2} #{-h}"
      else
        "M #{x_offset + a * (trunc(x / 2) - 0.5)} #{y_offset + h * (y - 1)}" <>
          " l #{a} #{0}" <>
          " l #{-a / 2} #{h}" <>
          " l #{-a / 2} #{-h}"
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

      d = "M #{left_x} #{left_y} l #{a} #{0}"
      content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
    end
  end

  def south_wall(maze, vertex) do
    a = triangle_base(maze)
    h = triangle_height(maze)

    if TriangularMaze.base_down?(vertex) do
      {top_x, top_y} = base_down_triangle_top(maze, vertex)

      d = "M #{top_x - a / 2} #{top_y + h} l #{a} #{0}"
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

        "M #{top_x} #{top_y} l #{-a / 2} #{h}"
      else
        {left_x, left_y} = base_up_triangle_left(maze, vertex)

        "M #{left_x} #{left_y} l #{a / 2} #{h}"
      end

    content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
  end

  def east_wall(maze, vertex) do
    a = triangle_base(maze)
    h = triangle_height(maze)

    d =
      if TriangularMaze.base_down?(vertex) do
        {top_x, top_y} = base_down_triangle_top(maze, vertex)

        "M #{top_x} #{top_y} l #{a / 2} #{h}"
      else
        {left_x, left_y} = base_up_triangle_left(maze, vertex)

        "M #{left_x + a} #{left_y} l #{-a / 2} #{h}"
      end

    content_tag(:path, "", d: d, fill: "transparent", style: line_style(maze))
  end

  defp base_down_triangle_top(maze, {x, y}) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    y_offset = svg_padding()
    top_x = x_offset + a * (trunc((x - 1) / 2) + 0.5)
    top_y = y_offset + h * (y - 1)
    {top_x, top_y}
  end

  defp base_up_triangle_left(maze, {x, y}) do
    a = triangle_base(maze)
    h = triangle_height(maze)
    x_offset = if Integer.mod(y, 2) == 1, do: svg_padding(), else: svg_padding() + a / 2
    y_offset = svg_padding()
    left_x = x_offset + a * (trunc(x / 2) - 0.5)
    left_y = y_offset + h * (y - 1)
    {left_x, left_y}
  end
end

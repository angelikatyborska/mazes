defmodule MazesWeb.RectangularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.Maze

  def square_size(maze) do
    Integer.floor_div(max_svg_width(), Enum.max([maze.width, maze.height]))
  end

  def svg_width(maze) do
    2 * svg_padding() + square_size(maze) * maze.width
  end

  def svg_height(maze) do
    2 * svg_padding() + square_size(maze) * maze.height
  end

  def square_center(maze, {x, y} = _vertex) do
    {
      svg_padding() + square_size(maze) * (x - 0.5),
      svg_padding() + square_size(maze) * (y - 0.5)
    }
  end

  def square(maze, {x, y} = vertex, settings, colors) do
    content_tag(:rect, "",
      width: format_number(square_size(maze) + 1),
      height: format_number(square_size(maze) + 1),
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
      x: format_number(svg_padding() + square_size(maze) * (x - 1)),
      y: format_number(svg_padding() + square_size(maze) * (y - 1))
    )
  end

  def north_wall(maze, {x, y} = _vertex) do
    content_tag(:line, "",
      style: line_style(maze),
      x1: format_number(svg_padding() + square_size(maze) * (x - 1)),
      y1: format_number(svg_padding() + square_size(maze) * (y - 1)),
      x2: format_number(svg_padding() + square_size(maze) * x),
      y2: format_number(svg_padding() + square_size(maze) * (y - 1))
    )
  end

  def south_wall(maze, {x, y} = _vertex) do
    content_tag(:line, "",
      style: line_style(maze),
      x1: format_number(svg_padding() + square_size(maze) * (x - 1)),
      y1: format_number(svg_padding() + square_size(maze) * y),
      x2: format_number(svg_padding() + square_size(maze) * x),
      y2: format_number(svg_padding() + square_size(maze) * y)
    )
  end

  def east_wall(maze, {x, y} = _vertex) do
    content_tag(:line, "",
      style: line_style(maze),
      x1: format_number(svg_padding() + square_size(maze) * x),
      y1: format_number(svg_padding() + square_size(maze) * (y - 1)),
      x2: format_number(svg_padding() + square_size(maze) * x),
      y2: format_number(svg_padding() + square_size(maze) * y)
    )
  end

  def west_wall(maze, {x, y} = _vertex) do
    content_tag(:line, "",
      style: line_style(maze),
      x1: format_number(svg_padding() + square_size(maze) * (x - 1)),
      y1: format_number(svg_padding() + square_size(maze) * (y - 1)),
      x2: format_number(svg_padding() + square_size(maze) * (x - 1)),
      y2: format_number(svg_padding() + square_size(maze) * y)
    )
  end
end

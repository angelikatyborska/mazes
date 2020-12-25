defmodule MazesWeb.MazeHelper do
  alias Mazes.MazeColors

  # doesn't matter that much because the svg is responsive
  # but affects how stroke looks like
  def max_svg_width, do: 1000

  def svg_padding, do: 16

  def solution(maze, solution, center_fun) do
    [h | t] = solution

    {x, y} = center_fun.(maze, h)

    d =
      t
      |> Enum.map(fn vertex ->
        {x, y} = center_fun.(maze, vertex)
        "L #{x} #{y}"
      end)
      |> Enum.join(" ")

    [
      Phoenix.HTML.Tag.content_tag(:path, "",
        d: "M #{x} #{y} #{d}",
        style: "stroke: white; opacity: 0.3; stroke-width: 6; stroke-linecap: round",
        fill: "transparent"
      ),
      Phoenix.HTML.Tag.content_tag(:path, "",
        d: "M #{x} #{y} #{d}",
        style: "stroke: black; stroke-width: 2; stroke-dasharray: 8 8; stroke-linecap: round",
        fill: "transparent"
      )
    ]
  end

  def from_to(maze, center_fun) do
    {from_cx, from_cy} = center_fun.(maze, maze.from)
    {to_cx, to_cy} = center_fun.(maze, maze.to)

    [
      Phoenix.HTML.Tag.content_tag(:circle, "",
        cx: from_cx,
        cy: from_cy,
        r: 6,
        style: "opacity: 0.3;",
        fill: "white"
      ),
      Phoenix.HTML.Tag.content_tag(:circle, "",
        cx: from_cx,
        cy: from_cy,
        r: 3,
        style: "",
        fill: "black"
      ),
      Phoenix.HTML.Tag.content_tag(:circle, "",
        cx: to_cx,
        cy: to_cy,
        r: 6,
        style: "opacity: 0.3;",
        fill: "white"
      ),
      Phoenix.HTML.Tag.content_tag(:circle, "",
        cx: to_cx,
        cy: to_cy,
        r: 3,
        style: "",
        fill: "black"
      )
    ]
  end

  def vertex_color(_maze, vertex, colors, show_colors, hue, saturation) do
    cond do
      show_colors && colors ->
        MazeColors.color(colors.distances[vertex], colors.max_distance, hue, saturation)

      true ->
        "white"
    end
  end

  def line_style(maze) do
    "stroke: black; #{do_line_style(maze)}"
  end

  def do_line_style(_maze) do
    "stroke-width: 2; stroke-linecap: round;"
  end

  def move_coordinate_by_radius_and_angle({cx, cy}, radius, alpha) do
    cond do
      alpha > 2 * :math.pi() ->
        move_coordinate_by_radius_and_angle({cx, cy}, radius, alpha - 2 * :math.pi())

      alpha < 0 ->
        move_coordinate_by_radius_and_angle({cx, cy}, radius, alpha + 2 * :math.pi())

      true ->
        ratio = alpha / :math.pi()

        {theta, x_delta_sign, y_delta_sign} =
          case ratio do
            ratio when ratio >= 0.0 and ratio < 0.5 ->
              {alpha, 1, -1}

            ratio when ratio >= 0.5 and ratio < 1.0 ->
              {:math.pi() - alpha, 1, 1}

            ratio when ratio >= 1.0 and ratio < 1.5 ->
              {alpha - :math.pi(), -1, 1}

            ratio when ratio >= 1.0 and ratio <= 2 ->
              {:math.pi() * 2 - alpha, -1, -1}
          end

        x = x_delta_sign * radius * :math.sin(theta) + cx
        y = y_delta_sign * radius * :math.cos(theta) + cy
        {x, y}
    end
  end

  def format_number(x) when is_integer(x) do
    "#{x}"
  end

  def format_number(x) when is_float(x) do
    to_string(:io_lib.format("~.4f", [x]))
  end
end

defmodule MazesWeb.MazeHelper do
  alias Mazes.MazeColors

  # doesn't matter that much because the svg is responsive
  # but affects how stroke looks like
  def max_svg_width, do: 1000

  def svg_padding, do: 16

  def vertex_color(maze, vertex, solution, show_solution, colors, show_colors, hue, saturation) do
    cond do
      vertex == maze.from ->
        "lightgray"

      vertex == maze.to ->
        "gray"

      show_solution && vertex in solution ->
        MazeColors.solution_color(hue, saturation)

      show_colors && colors ->
        MazeColors.color(colors.distances[vertex], colors.max_distance, hue, saturation)

      true ->
        "white"
    end
  end

  def vertex_fill(maze, vertex, solution, show_solution, colors, show_colors, hue, saturation) do
    fill =
      vertex_color(maze, vertex, solution, show_solution, colors, show_colors, hue, saturation)

    "style=\"fill: #{fill}\""
  end

  def line_style(maze) do
    stroke_width =
      case Enum.max(Enum.filter([maze[:width], maze[:height], maze[:radius]], & &1)) do
        n when n <= 16 -> 3
        n when n <= 32 -> 2
        _ -> 1
      end

    "stroke: black; stroke-width: #{stroke_width}; stroke-linecap: round;"
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
end

defmodule MazesWeb.PageView do
  use MazesWeb, :view

  alias Mazes.{Settings, MazeColors}

  # doesn't matter that much because the svg is responsive
  def max_svg_width, do: 1000

  def padding, do: 20

  def square_size(maze),
    do: Integer.floor_div(max_svg_width(), Enum.max([maze.width, maze.height]))

  def vertex_color(maze, vertex, solution, show_solution, colors, show_colors, hue) do
    cond do
      vertex == maze.from ->
        "lightgray"

      vertex == maze.to ->
        "gray"

      show_solution && vertex in solution ->
        MazeColors.solution_color(hue)

      show_colors && colors ->
        MazeColors.color(colors.distances[vertex], colors.max_distance, hue)

      true ->
        "white"
    end
  end

  def vertex_fill(maze, vertex, solution, show_solution, colors, show_colors, hue) do
    fill = vertex_color(maze, vertex, solution, show_solution, colors, show_colors, hue)

    "style=\"fill: #{fill}\""
  end

  def line_style(maze) do
    stroke_width =
      case Enum.max([maze.width, maze.height]) do
        n when n <= 16 -> 3
        n when n <= 32 -> 2
        n when n <= 64 -> 1
      end

    "stroke: black; stroke-width: #{stroke_width}; stroke-linecap: round;"
  end

  def opts_for_shape_select() do
    labels = %{
      "rectangle" => "Rectangle",
      "rectangle-with-mask" => "Rectangle with a mask",
      "circle" => "Circle",
      "hex" => "Hex"
    }

    Enum.map(Settings.shapes(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_algorithm_select do
    labels = %{
      "algorithm-aldous-broder" => "Aldous-Broder (unbiased)",
      "algorithm-wilsons" => "Wilson's (unbiased)",
      "algorithm-hunt-and-kill" => "Hunt and Kill (biased)",
      "algorithm-recursive-backtracker" => "Recursive Backtracker (biased)",
      "algorithm-binary-tree" => "Binary Tree (biased)",
      "algorithm-sidewinder" => "Sidewinder (biased)"
    }

    Enum.map(Settings.algorithms(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_entrance_exit_strategy_select do
    labels = %{
      "entrance-exit-hardest" => "Longest path",
      "entrance-exit-random" => "Random",
      "entrance-exit-nil" => "None"
    }

    Enum.map(Settings.entrance_exit_strategies(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_mask_select() do
    [
      %{path: "/images/maze_patterns/heart.png", label: "Heart", slug: "heart"},
      %{path: "/images/maze_patterns/amazing.png", label: "A*maze*ing!", slug: "amazing"}
    ]
  end

  def algorithm_disabled?(shape, algorithm) do
    if algorithm in Settings.algorithms_per_shape()[shape] do
      ""
    else
      "disabled"
    end
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

  def circular_maze_radius(maze) do
    trunc(max_svg_width() / maze.width) * maze.width
  end

  def circular_maze_center(maze) do
    center_x = padding() + circular_maze_radius(maze)
    center_y = padding() + circular_maze_radius(maze)
    {center_x, center_y}
  end

  def circular_maze_vertex_points(maze, column_count, ring, current_column) do
    center = circular_maze_center(maze)
    radius_delta = trunc(circular_maze_radius(maze) / maze.width)

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

defmodule MazesWeb.PageView do
  use MazesWeb, :view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeColors,
    MazeGeneration.HuntAndKillAlgorithm
  }

  def default_algorithm, do: HuntAndKillAlgorithm
  def default_width, do: 32
  def default_height, do: default_width()
  def default_hue, do: 200
  def min_width, do: 1
  def max_width, do: 50
  def min_height, do: min_width()
  def max_height, do: max_width()
  def min_hue, do: 0
  def max_hue, do: 359

  # doesn't matter that much because the svg is responsive
  def max_svg_width, do: 1000

  def padding, do: 20

  def square_size(maze),
    do: Integer.floor_div(max_svg_width(), Enum.max([maze.width, maze.height]))

  def vertex_class(maze, vertex, solution, show_solution) do
    class = []
    class = if show_solution && vertex in solution, do: ["highlight" | class], else: class
    class = if vertex == maze.from, do: ["start" | class], else: class
    class = if vertex == maze.to, do: ["end" | class], else: class
    Enum.join(class, "  ")
  end

  def vertex_fill(vertex, solution, show_solution, colors, show_colors, hue) do
    fill =
      show_colors && colors &&
        RectangularMazeColors.color(colors.distances[vertex], colors.max_distance, hue)

    fill =
      if show_solution && vertex in solution,
        do: Mazes.RectangularMazeColors.solution_color(hue),
        else: fill

    if fill, do: "style=\"fill: #{fill}\""
  end

  def opts_for_algorithm_select do
    [
      %{
        module: "Elixir.Mazes.MazeGeneration.BinaryTreeAlgorithm",
        slug: "algorithm-binary-tree",
        label: "Binary Tree (biased)"
      },
      %{
        module: "Elixir.Mazes.MazeGeneration.SidewinderAlgorithm",
        slug: "algorithm-sidewinder",
        label: "Sidewinder (biased)"
      },
      %{
        module: "Elixir.Mazes.MazeGeneration.AldousBroderAlgorithm",
        slug: "algorithm-aldous-broder",
        label: "Aldous-Broder (unbiased)"
      },
      %{
        module: "Elixir.Mazes.MazeGeneration.WilsonsAlgorithm",
        slug: "algorithm-wilsons",
        label: "Wilson's (unbiased)"
      },
      %{
        module: "Elixir.Mazes.MazeGeneration.HuntAndKillAlgorithm",
        slug: "algorithm-hunt-and-kill",
        label: "Hunt and Kill (biased)"
      },
      %{
        module: "Elixir.Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm",
        slug: "algorithm-recursive-backtracker",
        label: "Recursive Backtracker (biased)"
      }
    ]
  end

  def opts_for_entrance_exit_strategy_select do
    [
      %{
        function: "set_longest_path_from_and_to",
        slug: "entrance-exit-hardest",
        label: "Longest path"
      },
      %{
        function: "set_random_border_from_and_to",
        slug: "entrance-exit-random",
        label: "Random"
      },
      %{
        function: "nil",
        slug: "entrance-exit-nil",
        label: "None"
      }
    ]
  end

  def default_state do
    %{
      algorithm: default_algorithm(),
      entrance_exit_strategy: :set_longest_path_from_and_to,
      width: default_width(),
      height: default_height(),
      solution: [],
      show_solution: false,
      colors: nil,
      show_colors: false,
      longest_path: nil,
      hue: default_hue()
    }
  end

  def update_maze_settings(form_data, state) do
    %{
      "algorithm" => algorithm,
      "width" => width,
      "height" => height,
      "hue" => hue,
      "entrance_exit_strategy" => entrance_exit_strategy
    } = form_data

    show_colors = form_data["show_colors"]
    show_solution = form_data["show_solution"]

    width = String.to_integer(width)
    width = if width < min_width(), do: min_width(), else: width
    width = if width > max_width(), do: max_width(), else: width
    height = String.to_integer(height)
    height = if height < min_height(), do: min_height(), else: height
    height = if height > max_height(), do: max_height(), else: height
    hue = String.to_integer(hue)
    hue = if hue < min_hue(), do: min_hue(), else: hue
    hue = if hue > max_hue(), do: max_hue(), else: hue
    show_solution = show_solution === "on"
    show_colors = show_colors === "on"

    algorithm =
      if algorithm in Enum.map(opts_for_algorithm_select(), & &1.module) do
        String.to_existing_atom(algorithm)
      else
        default_algorithm()
      end

    entrance_exit_strategy =
      if to_string(entrance_exit_strategy) in Enum.map(
           opts_for_entrance_exit_strategy_select(),
           & &1.function
         ) do
        String.to_existing_atom(entrance_exit_strategy)
      else
        :set_longest_path_from_and_to
      end

    [
      {:width, width},
      {:height, height},
      {:hue, hue},
      {:algorithm, algorithm},
      {:entrance_exit_strategy, entrance_exit_strategy},
      {:show_solution, show_solution},
      {:show_colors, show_colors}
    ]
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      if state[key] != value, do: Map.put(acc, key, value), else: acc
    end)
  end
end

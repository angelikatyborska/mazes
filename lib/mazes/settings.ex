defmodule Mazes.Settings do
  defstruct([
    :shape,
    :algorithm,
    :entrance_exit_strategy,
    :width,
    :height,
    :radius,
    :side_length,
    :show_solution,
    :show_colors,
    :hue,
    :saturation,
    :mask
  ])

  alias Mazes.{
    RectangularMaze,
    RectangularMazeWithMask,
    CircularMaze,
    HexagonalMaze,
    TriangularMaze,
    MazeGeneration.HuntAndKillAlgorithm
  }

  def default_shape, do: RectangularMaze
  def default_mask, do: hd(mask_files()).path
  def default_algorithm, do: HuntAndKillAlgorithm
  def default_entrance_exit_strategy, do: :set_longest_path_from_and_to
  def default_width, do: 20
  def default_height, do: default_width()
  def default_radius, do: 10
  def default_side_length, do: 15
  def default_hue, do: 200
  def default_saturation, do: 60
  def min_width, do: 2
  def max_width, do: 50
  def min_height, do: min_width()
  def max_height, do: max_width()
  def min_radius, do: 2
  def max_radius, do: 30
  def min_side_length, do: 2
  def max_side_length, do: 30
  def min_hue, do: 0
  def max_hue, do: 359
  def min_saturation, do: 0
  def max_saturation, do: 100

  def default_settings do
    %__MODULE__{
      shape: default_shape(),
      algorithm: default_algorithm(),
      entrance_exit_strategy: default_entrance_exit_strategy(),
      width: default_width(),
      height: default_height(),
      radius: default_radius(),
      side_length: default_side_length(),
      show_solution: false,
      show_colors: false,
      hue: default_hue(),
      saturation: default_saturation(),
      mask: default_mask()
    }
  end

  def shapes do
    [
      %{
        module: RectangularMaze,
        slug: "rectangle"
      },
      %{
        module: HexagonalMaze,
        slug: "hex"
      },
      %{
        module: TriangularMaze,
        slug: "triangle"
      },
      %{
        module: CircularMaze,
        slug: "circle"
      },
      %{
        module: RectangularMazeWithMask,
        slug: "rectangle-with-mask"
      }
    ]
  end

  def algorithms do
    [
      %{
        module: Mazes.MazeGeneration.AldousBroderAlgorithm,
        slug: "algorithm-aldous-broder"
      },
      %{
        module: Mazes.MazeGeneration.WilsonsAlgorithm,
        slug: "algorithm-wilsons"
      },
      %{
        module: Mazes.MazeGeneration.HuntAndKillAlgorithm,
        slug: "algorithm-hunt-and-kill"
      },
      %{
        module: Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm,
        slug: "algorithm-recursive-backtracker"
      },
      %{
        module: Mazes.MazeGeneration.BinaryTreeAlgorithm,
        slug: "algorithm-binary-tree"
      },
      %{
        module: Mazes.MazeGeneration.SidewinderAlgorithm,
        slug: "algorithm-sidewinder"
      }
    ]
  end

  def entrance_exit_strategies do
    [
      %{
        function: :set_longest_path_from_and_to,
        slug: "entrance-exit-hardest"
      },
      %{
        function: :set_random_from_and_to,
        slug: "entrance-exit-random"
      },
      %{
        function: nil,
        slug: "entrance-exit-nil"
      }
    ]
  end

  def maze_options_per_shape do
    %{
      RectangularMaze => [:width, :height],
      RectangularMazeWithMask => [:mask],
      CircularMaze => [:radius],
      HexagonalMaze => [:radius],
      TriangularMaze => [:side_length]
    }
  end

  def algorithms_per_shape do
    shapes()
    |> Enum.map(fn shape ->
      algorithms =
        algorithms()
        |> Enum.map(fn algorithm -> algorithm.module end)
        |> Enum.filter(fn algorithm -> shape.module in algorithm.supported_maze_types() end)

      {shape.module, algorithms}
    end)
    |> Enum.into(%{})
  end

  def mask_files() do
    [
      %{path: "/images/maze_patterns/heart.png", slug: "heart"},
      %{path: "/images/maze_patterns/star.png", slug: "star"},
      %{path: "/images/maze_patterns/puzzle.png", slug: "puzzle"},
      %{path: "/images/maze_patterns/amazing.png", slug: "amazing"}
    ]
  end

  def preload_masks_from_files() do
    mask_files()
    |> Enum.map(fn %{path: path} ->
      {:ok, file} = Imagineer.load(Path.join("priv/static", path))
      {path, file}
    end)
    |> Enum.into(%{})
  end

  def get_opts_for_generate(settings) do
    opts = maze_options_per_shape()[settings.shape]
    Enum.map(opts, &{&1, Map.get(settings, &1)})
  end

  def update_maze_settings(form_data, settings) do
    %{
      "shape" => shape,
      "hue" => hue,
      "saturation" => saturation,
      "entrance_exit_strategy" => entrance_exit_strategy
    } = form_data

    algorithm = form_data["algorithm"]
    width = form_data["width"]
    height = form_data["height"]
    radius = form_data["radius"]
    side_length = form_data["side_length"]
    mask = form_data["mask"]
    show_colors = form_data["show_colors"]
    show_solution = form_data["show_solution"]

    width = change_int(width, min_width(), max_width()) || settings.width
    height = change_int(height, min_height(), max_height()) || settings.height
    radius = change_int(radius, min_radius(), max_radius()) || settings.radius

    side_length =
      change_int(side_length, min_side_length(), max_side_length()) || settings.side_length

    hue = change_int(hue, min_hue(), max_hue()) || settings.hue
    saturation = change_int(saturation, min_saturation(), max_saturation()) || settings.saturation

    show_solution = show_solution === "on"
    show_colors = show_colors === "on"

    shape =
      case Enum.find(shapes(), &(&1.slug === shape)) do
        nil -> default_shape()
        %{module: module} -> module
      end

    algorithm =
      case Enum.find(algorithms(), &(&1.slug === algorithm)) do
        nil ->
          default_algorithm()

        %{module: module} ->
          if module in algorithms_per_shape()[shape] do
            module
          else
            default_algorithm()
          end
      end

    entrance_exit_strategy =
      case Enum.find(entrance_exit_strategies(), &(&1.slug === entrance_exit_strategy)) do
        nil -> default_entrance_exit_strategy()
        %{function: function} -> function
      end

    mask =
      case Enum.find(mask_files(), &(&1.slug === mask)) do
        nil when mask == "custom_mask" -> :custom_mask
        nil -> default_mask()
        %{path: path} -> path
      end

    %__MODULE__{
      settings
      | width: width,
        height: height,
        radius: radius,
        side_length: side_length,
        hue: hue,
        saturation: saturation,
        shape: shape,
        algorithm: algorithm,
        mask: mask,
        entrance_exit_strategy: entrance_exit_strategy,
        show_solution: show_solution,
        show_colors: show_colors
    }
  end

  defp change_int(value, min, max) do
    if value && value != "" do
      value = String.to_integer(value)
      value = if value < min, do: min, else: value
      if value > max, do: max, else: value
    end
  end
end

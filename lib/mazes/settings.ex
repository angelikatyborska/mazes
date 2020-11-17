defmodule Mazes.Settings do
  defstruct([
    :shape,
    :algorithm,
    :entrance_exit_strategy,
    :width,
    :height,
    :rings,
    :show_solution,
    :show_colors,
    :hue,
    :mask
  ])

  alias Mazes.{
    RectangularMaze,
    RectangularMazeWithMask,
    CircularMaze,
    MazeGeneration.HuntAndKillAlgorithm
  }

  def default_shape, do: RectangularMaze
  def default_mask, do: hd(mask_files()).path
  def default_algorithm, do: HuntAndKillAlgorithm
  def default_entrance_exit_strategy, do: :set_longest_path_from_and_to
  def default_width, do: 32
  def default_height, do: default_width()
  def default_rings, do: 8
  def default_hue, do: 200
  def min_width, do: 2
  def max_width, do: 64
  def min_height, do: min_width()
  def max_height, do: max_width()
  def min_rings, do: 2
  def max_rings, do: 32
  def min_hue, do: 0
  def max_hue, do: 359

  def default_settings do
    %__MODULE__{
      shape: default_shape(),
      algorithm: default_algorithm(),
      entrance_exit_strategy: default_entrance_exit_strategy(),
      width: default_width(),
      height: default_height(),
      rings: default_rings(),
      show_solution: false,
      show_colors: false,
      hue: default_hue(),
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
        module: RectangularMazeWithMask,
        slug: "rectangle-with-mask"
      },
      %{
        module: CircularMaze,
        slug: "circle"
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
      CircularMaze => [:rings]
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
      "entrance_exit_strategy" => entrance_exit_strategy
    } = form_data

    algorithm = form_data["algorithm"]
    width = form_data["width"]
    height = form_data["height"]
    rings = form_data["rings"]
    mask = form_data["mask"]
    show_colors = form_data["show_colors"]
    show_solution = form_data["show_solution"]

    width =
      if width && width != "" do
        width = String.to_integer(width)
        width = if width < min_width(), do: min_width(), else: width
        if width > max_width(), do: max_width(), else: width
      else
        settings.width
      end

    height =
      if height && height != "" do
        height = String.to_integer(height)
        height = if height < min_height(), do: min_height(), else: height
        if height > max_height(), do: max_height(), else: height
      else
        settings.height
      end

    rings =
      if rings && rings != "" do
        rings = String.to_integer(rings)
        rings = if rings < min_rings(), do: min_rings(), else: rings
        if rings > max_rings(), do: max_rings(), else: rings
      else
        settings.rings
      end

    hue = String.to_integer(hue)
    hue = if hue < min_hue(), do: min_hue(), else: hue
    hue = if hue > max_hue(), do: max_hue(), else: hue
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
        nil -> default_mask()
        %{path: path} -> path
      end

    %__MODULE__{
      settings
      | width: width,
        height: height,
        rings: rings,
        hue: hue,
        shape: shape,
        algorithm: algorithm,
        mask: mask,
        entrance_exit_strategy: entrance_exit_strategy,
        show_solution: show_solution,
        show_colors: show_colors
    }
  end
end

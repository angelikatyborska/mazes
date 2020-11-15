defmodule Mazes.Generate do
  alias Mazes.{Settings, MazeEntranceAndExit, MazeDistances}

  def from_settings(%Settings{} = settings, masks) do
    opts = Settings.get_opts_for_generate(settings)

    opts =
      if Keyword.get(opts, :mask) do
        Keyword.put(opts, :file, masks[Keyword.get(opts, :mask)])
      else
        opts
      end

    maze =
      settings.algorithm.generate(
        opts,
        settings.shape
      )

    maze =
      if settings.entrance_exit_strategy do
        apply(MazeEntranceAndExit, settings.entrance_exit_strategy, [maze])
      else
        maze
      end

    solution =
      if maze.from && maze.to,
        do: MazeDistances.shortest_path(maze, maze.from, maze.to),
        else: []

    from = maze.from || maze.module.center(maze)
    distances = MazeDistances.distances(maze, from)

    {_, max_distance} = MazeDistances.find_max_vertex_by_distance(maze, from, distances)

    colors = %{distances: distances, max_distance: max_distance}

    longest_path =
      if settings.entrance_exit_strategy == :set_longest_path_from_and_to do
        solution
      else
        temp_maze = MazeEntranceAndExit.set_longest_path_from_and_to(maze)
        MazeDistances.shortest_path(temp_maze, temp_maze.from, temp_maze.to)
      end

    %{maze: maze, solution: solution, colors: colors, longest_path: longest_path}
  end
end

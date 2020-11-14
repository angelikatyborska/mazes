defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    MazeDistances,
    MazeEntranceAndExit,
    Settings
  }

  alias MazesWeb.PageView

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :settings, Settings.default_settings())

    socket =
      if connected?(socket) do
        masks = Settings.preload_masks_from_files()
        socket = assign(socket, :masks, masks)

        generate(socket)
      else
        empty(socket)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("generate", _value, socket) do
    socket = generate(socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("settings_change", form_data, socket) do
    settings = Settings.update_maze_settings(form_data, socket.assigns.settings)
    socket = assign(socket, :settings, settings)

    {:noreply, socket}
  end

  defp empty(socket) do
    socket
    |> assign(
      :maze,
      RectangularMaze.new(
        width: socket.assigns.settings.width,
        height: socket.assigns.settings.height
      )
    )
    |> assign(:solution, [])
    |> assign(:colors, nil)
    |> assign(:longest_path, [])
  end

  defp generate(socket) do
    opts = Settings.get_opts_for_generate(socket.assigns.settings)

    opts =
      if Keyword.get(opts, :mask) do
        Keyword.put(opts, :file, socket.assigns.masks[Keyword.get(opts, :mask)])
      else
        opts
      end

    maze =
      socket.assigns.settings.algorithm.generate(
        opts,
        socket.assigns.settings.shape
      )

    maze =
      if socket.assigns.settings.entrance_exit_strategy do
        apply(MazeEntranceAndExit, socket.assigns.settings.entrance_exit_strategy, [maze])
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
      if socket.assigns.settings.entrance_exit_strategy == :set_longest_path_from_and_to do
        solution
      else
        temp_maze = Mazes.MazeEntranceAndExit.set_longest_path_from_and_to(maze)
        MazeDistances.shortest_path(temp_maze, temp_maze.from, temp_maze.to)
      end

    socket
    |> assign(:maze, maze)
    |> assign(:solution, solution)
    |> assign(:colors, colors)
    |> assign(:longest_path, longest_path)
  end
end

defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeDistances,
    RectangularMazeEntranceAndExit,
    RectangularMazeColors,
    SidewinderAlgorithm
  }

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        algorithm: SidewinderAlgorithm,
        entrance_exit_strategy: :set_longest_path_from_and_to,
        width: 32,
        height: 32,
        solution: [],
        colors: nil,
        hue: 155
      )

    maze =
      if connected?(socket) do
        generate(socket)
      else
        empty(socket)
      end

    socket =
      socket
      |> assign(maze: maze)

    {:ok, socket}
  end

  @impl true
  def handle_event("generate", _value, socket) do
    socket =
      socket
      |> assign(:maze, generate(socket))
      |> assign(:solution, [])
      |> assign(:colors, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("settings_change", form_data, socket) do
    %{
      "algorithm" => algorithm,
      "width" => width,
      "height" => height,
      "hue" => hue,
      "entrance_exit_strategy" => entrance_exit_strategy
    } = form_data

    width = String.to_integer(width)
    width = if width > 50, do: 50, else: width
    height = String.to_integer(height)
    height = if height > 50, do: 50, else: height
    hue = String.to_integer(hue)
    hue = if hue > 255, do: 255, else: hue
    algorithm = String.to_existing_atom(algorithm)
    entrance_exit_strategy = String.to_existing_atom(entrance_exit_strategy)

    entrance_exit_strategy =
      if entrance_exit_strategy in [
           :set_longest_path_from_and_to,
           :set_random_border_from_and_to,
           nil
         ] do
        entrance_exit_strategy
      else
        :set_longest_path_from_and_to
      end

    socket =
      socket
      |> assign(width: width)
      |> assign(height: height)
      |> assign(hue: hue)
      |> assign(algorithm: algorithm)
      |> assign(entrance_exit_strategy: entrance_exit_strategy)

    {:noreply, socket}
  end

  @impl true
  def handle_event("solve", _value, socket) do
    solution =
      RectangularMazeDistances.shortest_path(
        socket.assigns.maze,
        socket.assigns.maze.from,
        socket.assigns.maze.to
      )

    {:noreply, assign(socket, :solution, solution)}
  end

  def handle_event("color", _value, socket) do
    maze = socket.assigns.maze
    from = maze.from || {trunc(Float.ceil(maze.width / 2)), trunc(Float.ceil(maze.height / 2))}

    distances = RectangularMazeDistances.distances(socket.assigns.maze, from)

    {_, max_distance} =
      RectangularMazeDistances.find_max_vertex_by_distance(maze, from, distances)

    {:noreply, assign(socket, :colors, %{distances: distances, max_distance: max_distance})}
  end

  defp empty(socket) do
    RectangularMaze.new(socket.assigns.width, socket.assigns.height)
  end

  defp generate(socket) do
    maze = socket.assigns.algorithm.generate(socket.assigns.width, socket.assigns.height)

    if socket.assigns.entrance_exit_strategy do
      apply(RectangularMazeEntranceAndExit, socket.assigns.entrance_exit_strategy, [maze])
    else
      maze
    end
  end
end

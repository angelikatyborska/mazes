defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeDistances,
    RectangularMazeEntranceAndExit,
  }

  alias MazesWeb.PageView

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, PageView.default_state())

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
    assigns = PageView.update_maze_settings(form_data, socket.assigns)
    socket = assign(socket, assigns)

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

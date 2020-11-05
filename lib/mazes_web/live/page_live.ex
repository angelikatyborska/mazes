defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeDistances,
    BinaryTreeAlgorithm
  }

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, algorithm: BinaryTreeAlgorithm, width: 32, height: 32, solution: [])

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
  def handle_event("regenerate", _value, socket) do
    socket =
      socket
      |> assign(:maze, generate(socket))
      |> assign(:solution, [])

    {:noreply, socket}
  end

  @impl true
  def handle_event("settings_change", form_data, socket) do
    %{
      "algorithm" => algorithm,
      "width" => width,
      "height" => height
    } = form_data

    width = String.to_integer(width)
    width = if width > 50, do: 50, else: width
    height = String.to_integer(height)
    height = if height > 50, do: 50, else: height
    algorithm = String.to_existing_atom(algorithm)

    socket =
      socket
      |> assign(width: width)
      |> assign(height: height)
      |> assign(algorithm: algorithm)

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

  defp empty(socket) do
    RectangularMaze.new(socket.assigns.width, socket.assigns.height)
  end

  defp generate(socket) do
    socket.assigns.algorithm.generate(socket.assigns.width, socket.assigns.height)
  end
end

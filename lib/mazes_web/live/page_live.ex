defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeDistances,
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
        solution: []
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
      "height" => height,
      "entrance_exit_strategy" => entrance_exit_strategy
    } = form_data

    width = String.to_integer(width)
    width = if width > 50, do: 50, else: width
    height = String.to_integer(height)
    height = if height > 50, do: 50, else: height
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

  defp empty(socket) do
    RectangularMaze.new(socket.assigns.width, socket.assigns.height)
  end

  defp generate(socket) do
    maze = socket.assigns.algorithm.generate(socket.assigns.width, socket.assigns.height)

    if socket.assigns.entrance_exit_strategy do
      apply(RectangularMazeDistances, socket.assigns.entrance_exit_strategy, [maze])
    else
      maze
    end
  end
end

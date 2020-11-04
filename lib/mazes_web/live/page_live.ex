defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    RectangularMazeDistances,
    BinaryTreeAlgorithm,
    SidewinderAlgorithm
  }

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, algorithm: BinaryTreeAlgorithm, width: 8, height: 8, solution: [])

    algorithm_state =
      if connected?(socket) do
        execute(new(socket), socket.assigns.algorithm)
      else
        new(socket)
      end

    socket =
      socket
      |> assign(algorithm_state: algorithm_state)

    {:ok, socket}
  end

  @impl true
  def handle_event("regenerate", _value, socket) do
    algorithm_state = execute(new(socket), socket.assigns.algorithm)

    socket =
      socket
      |> assign(:algorithm_state, algorithm_state)
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
      RectangularMazeDistances.path(
        socket.assigns.algorithm_state.maze,
        {1, 1},
        {socket.assigns.width, socket.assigns.height}
      )

    {:noreply, assign(socket, :solution, solution)}
  end

  defp new(socket) do
    socket.assigns.algorithm.init(socket.assigns.width, socket.assigns.height)
  end

  defp execute(algorithm_state, algorithm) do
    case algorithm.next_step(algorithm_state) do
      {:cont, algorithm_state} ->
        execute(algorithm_state, algorithm)

      {:halt, algorithm_state} ->
        algorithm_state
    end
  end
end

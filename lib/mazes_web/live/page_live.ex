defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view
  alias Mazes.{RectangularMaze, BinaryTreeAlgorithm, SidewinderAlgorithm}

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, algorithm: BinaryTreeAlgorithm, width: 8, height: 8)

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
    {:noreply, assign(socket, :algorithm_state, algorithm_state)}
  end

  @impl true
  def handle_event("settings_change", form_data, socket) do
    %{
      "algorithm" => algorithm,
      "width" => width,
      "height" => height
    } = form_data

    socket =
      socket
      |> assign(width: String.to_integer(width))
      |> assign(height: String.to_integer(height))
      |> assign(algorithm: String.to_existing_atom(algorithm))

    {:noreply, socket}
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

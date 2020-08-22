defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view
  alias Mazes.{RectangularMaze, BinaryTreeAlgorithm}

  def animation_duration do
    500
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      if connected?(socket) do
        algorithm_state = BinaryTreeAlgorithm.init(10, 10)

        Process.send_after(self(), :next_step, animation_duration())

        assign(socket, algorithm_state: algorithm_state)
      else
        algorithm_state = BinaryTreeAlgorithm.init(10, 10)
        assign(socket, algorithm_state: algorithm_state)
      end

    {:ok, socket}
  end

  @impl true
  def handle_info(:next_step, socket) do
    case BinaryTreeAlgorithm.next_step(socket.assigns.algorithm_state) do
      {:cont, algorithm_state} ->
        Process.send_after(self(), :next_step, animation_duration())
        socket = assign(socket, algorithm_state: algorithm_state)
        {:noreply, socket}

      {:halt, algorithm_state} ->
        socket = assign(socket, algorithm_state: algorithm_state)
        {:noreply, socket}
    end
  end
end

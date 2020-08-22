defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, maze: Mazes.RectangularMaze.new(10, 10))}
  end
end

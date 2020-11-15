defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    Settings,
    Generate
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
    %{maze: maze, solution: solution, colors: colors, longest_path: longest_path} =
      Generate.from_settings(socket.assigns.settings, socket.assigns.masks)

    socket
    |> assign(:maze, maze)
    |> assign(:solution, solution)
    |> assign(:colors, colors)
    |> assign(:longest_path, longest_path)
  end
end

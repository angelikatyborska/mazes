defmodule MazesWeb.PageLive do
  use MazesWeb, :live_view

  alias Mazes.{
    RectangularMaze,
    Settings,
    Generate,
    Mask
  }

  alias MazesWeb.PageView

  def max_custom_mask_file_size() do
    16_000
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:settings, Settings.default_settings())
      |> assign(:custom_mask, nil)
      |> allow_upload(:custom_mask,
        accept: ~w(.png),
        max_entries: 1,
        max_file_size: max_custom_mask_file_size()
      )

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
    files =
      consume_uploaded_entries(socket, :custom_mask, fn %{path: path}, _ ->
        {:ok, file} = Imagineer.load(path)
        file
      end)

    file =
      case files do
        [file] -> file
        _ -> nil
      end

    socket = if file, do: assign(socket, :custom_mask, file), else: socket

    socket = generate(socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("settings_change", form_data, socket) do
    {uploaded_entries_completed, uploaded_entries_in_progress} =
      uploaded_entries(socket, :custom_mask)

    uploaded_entries = uploaded_entries_completed ++ uploaded_entries_in_progress

    socket =
      Enum.reduce(uploaded_entries, socket, fn entry, socket ->
        if entry.client_size >= max_custom_mask_file_size() do
          socket
          |> cancel_upload(:custom_mask, entry.ref)
          |> put_flash(
            :error,
            "Selected file was #{entry.client_size} bytes but maximum allowed file size is #{
              max_custom_mask_file_size()
            } bytes."
          )
        else
          socket
        end
      end)

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
    custom_mask =
      if socket.assigns.settings.mask == :custom_mask do
        socket.assigns.custom_mask
      else
        nil
      end

    case Mask.validate_mask(custom_mask) do
      :ok ->
        %{maze: maze, solution: solution, colors: colors, longest_path: longest_path} =
          Generate.from_settings(
            socket.assigns.settings,
            socket.assigns.masks,
            custom_mask
          )

        socket
        |> assign(:maze, maze)
        |> assign(:solution, solution)
        |> assign(:colors, colors)
        |> assign(:longest_path, longest_path)

      {:error, error} ->
        socket
        |> put_flash(:error, "Invalid mask file. #{error}")
    end
  end
end

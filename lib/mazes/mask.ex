defmodule Mazes.Mask do
  alias Mazes.{MazeDistances, RectangularMazeWithMask, Maze}

  def validate_mask(nil), do: :ok

  def validate_mask(file) do
    file =
      case file do
        filename when is_binary(filename) ->
          {:ok, file} = Imagineer.load(filename)
          file

        %Imagineer.Image.PNG{} ->
          file
      end

    height = length(file.pixels)
    width = length(hd(file.pixels))

    if width * height > 64 * 64 do
      {:error,
       "Expected file to have no more than #{64 * 64} pixels, got #{width * height} (#{width} x #{
         height
       })"}
    else
      maze = RectangularMazeWithMask.new(file: file, all_vertices_adjacent?: true)
      distances = MazeDistances.distances(maze, RectangularMazeWithMask.center(maze))

      if Enum.any?(Maze.vertices(maze), fn vertex -> !distances[vertex] end) do
        {:error, "All black pixels have to form a single unbroken shape."}
      else
        :ok
      end
    end
  end

  def masked_vertices(pixels) do
    threshold = 4

    pixels
    |> Enum.with_index()
    |> Enum.reduce([], fn {pixels, row}, acc ->
      pixels
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {pixel, column}, acc2 ->
        # pixel can be {r, g, b} or {r, g, b, a}

        case pixel do
          {r, g, b} when r < threshold and g < threshold and b < threshold ->
            acc2

          {r, g, b, a}
          when r < threshold and g < threshold and b < threshold and a >= 255 - threshold ->
            acc2

          _ ->
            [{column + 1, row + 1} | acc2]
        end
      end)
    end)
  end
end

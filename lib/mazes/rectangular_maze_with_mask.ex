defmodule Mazes.RectangularMazeWithMask do
  @behaviour Mazes.Maze
  alias Mazes.{Maze, RectangularMaze}

  @doc "Returns a rectangular maze with given size, either with all walls or no walls"
  @impl true
  def new(opts) do
    file = Keyword.get(opts, :file)

    if file do
      new_from_file(file)
    else
      width = Keyword.get(opts, :width, 10)
      height = Keyword.get(opts, :height, 10)
      all_vertices_adjacent? = Keyword.get(opts, :all_vertices_adjacent?, false)

      mask_vertices = Keyword.get(opts, :mask_vertices, [])

      vertices =
        Enum.reduce(1..width, [], fn x, acc ->
          Enum.reduce(1..height, acc, fn y, acc2 ->
            vertex = {x, y}

            if vertex in mask_vertices do
              acc2
            else
              [vertex | acc2]
            end
          end)
        end)

      adjacency_matrix =
        vertices
        |> Enum.map(fn {from_x, from_y} = from ->
          value =
            vertices
            |> Enum.filter(fn {x, y} ->
              {x, y} in [
                {from_x - 1, from_y},
                {from_x + 1, from_y},
                {from_x, from_y - 1},
                {from_x, from_y + 1}
              ]
            end)
            |> Enum.map(&{&1, all_vertices_adjacent?})
            |> Enum.into(%{})

          {from, value}
        end)
        |> Enum.into(%{})

      %{
        width: width,
        height: height,
        adjacency_matrix: adjacency_matrix,
        module: __MODULE__,
        from: nil,
        to: nil
      }
    end
  end

  @impl true
  def center(maze) do
    vertices = Maze.vertices(maze)
    center = {trunc(Float.ceil(maze.width / 2)), trunc(Float.ceil(maze.height / 2))}
    approximate_center(maze, vertices, center, [center])
  end

  defp approximate_center(maze, vertices, {x, y} = real_center, candidates) do
    if center = Enum.find(candidates, &(&1 in vertices)) do
      center
    else
      new_candidates =
        candidates
        |> Enum.reduce([], fn candidate, acc ->
          [north(candidate), east(candidate), south(candidate), west(candidate) | acc]
        end)
        |> Enum.uniq()
        |> Enum.sort_by(fn {x1, y1} ->
          :math.pow(x1 - x, 2) + :math.pow(y1 - y, 2)
        end)

      new_candidates = new_candidates -- candidates
      approximate_center(maze, vertices, real_center, new_candidates)
    end
  end

  # Not part of the behavior, functions needed for drawing the grid

  def north(vertex), do: RectangularMaze.north(vertex)
  def south(vertex), do: RectangularMaze.south(vertex)
  def east(vertex), do: RectangularMaze.east(vertex)
  def west(vertex), do: RectangularMaze.west(vertex)

  defp new_from_file(filename) when is_binary(filename) do
    {:ok, file} = Imagineer.load(filename)
    new_from_file(file)
  end

  defp new_from_file(%Imagineer.Image.PNG{pixels: pixels}) do
    threshold = 100
    height = length(pixels)
    width = length(hd(pixels))

    mask_vertices =
      pixels
      |> Enum.with_index()
      |> Enum.reduce([], fn {pixels, row}, acc ->
        pixels
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {pixel, column}, acc2 ->
          # pixel can be {r, g, b} or {r, g, b, a}
          if Enum.all?(Tuple.to_list(pixel), &(&1 > threshold)) do
            [{column + 1, row + 1} | acc2]
          else
            acc2
          end
        end)
      end)

    new(width: width, height: height, mask_vertices: mask_vertices)
  end
end

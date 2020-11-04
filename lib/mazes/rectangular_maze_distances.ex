defmodule Mazes.RectangularMazeDistances do
  defstruct [:maze, :start_cell, :distances]

  alias Mazes.RectangularMaze

  @doc "Returns a list of vertices that form the shortest path from the start to the end vertex"
  def path(maze, from, to) do
    distances = distances(maze, to)
    path(maze, from, to, distances, [from])
  end

  defp path(maze, to, to, _, acc), do: Enum.reverse(acc)

  defp path(maze, from, to, distances, acc) do
    adjacent = RectangularMaze.adjacent_vertices(maze, from)

    if adjacent == [] do
      nil
    else
      next = Enum.min_by(adjacent, &distances[&1])
      path(maze, next, to, distances, [next | acc])
    end
  end

  @doc "Returns a map of cells where the values are distances from the starting cell"
  def distances(maze, start_cell) do
    distances(maze, [start_cell], 0, %{})
  end

  defp distances(_, [], _, distances), do: distances

  defp distances(maze, cells, distance, distances) do
    distances =
      Enum.reduce(cells, distances, fn cell, acc ->
        Map.put_new(acc, cell, distance)
      end)

    adjacent_unvisited_cells =
      cells
      |> Enum.flat_map(&RectangularMaze.adjacent_vertices(maze, &1))
      |> Enum.uniq()
      |> Enum.filter(&(!distances[&1]))

    distances(maze, adjacent_unvisited_cells, distance + 1, distances)
  end
end

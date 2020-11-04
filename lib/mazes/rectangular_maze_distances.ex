defmodule Mazes.RectangularMazeDistances do
  defstruct [:maze, :start_cell, :distances]

  alias Mazes.RectangularMaze

  @doc "Returns a map of cells where the values are distances from the starting cell"
  def calculate(maze, start_cell) do
    calculate(maze, [start_cell], 0, %{})
  end

  defp calculate(_, [], _, distances), do: distances

  defp calculate(maze, cells, distance, distances) do
    distances =
      Enum.reduce(cells, distances, fn cell, acc ->
        Map.put_new(acc, cell, distance)
      end)

    adjacent_unvisited_cells =
      cells
      |> Enum.flat_map(&RectangularMaze.adjacent_cells(maze, &1))
      |> Enum.uniq()
      |> Enum.filter(&(!distances[&1]))

    calculate(maze, adjacent_unvisited_cells, distance + 1, distances)
  end
end

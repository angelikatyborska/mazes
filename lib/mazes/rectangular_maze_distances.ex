defmodule Mazes.RectangularMazeDistances do
  alias Mazes.RectangularMaze

  @doc "Returns a list of vertices that form the shortest path from the start to the end vertex"
  def shortest_path(maze, from, to) do
    distances = distances(maze, to)
    shortest_path(maze, from, to, distances, [from])
  end

  defp shortest_path(_maze, to, to, _, acc), do: Enum.reverse(acc)

  defp shortest_path(maze, from, to, distances, acc) do
    adjacent = RectangularMaze.adjacent_vertices(maze, from)

    if adjacent == [] do
      nil
    else
      next = Enum.min_by(adjacent, &distances[&1])
      shortest_path(maze, next, to, distances, [next | acc])
    end
  end

  @doc "Returns the vertex that is further away from the given one and its distance"
  def find_max_vertex_by_distance(maze, from, distances \\ nil) do
    distances = if distances, do: distances, else: distances(maze, from)

    Enum.max_by(distances, fn {_, distance} -> distance end)
  end

  @doc "Returns a map of cells where the values are distances from the starting cell"
  def distances(maze, from) do
    distances(maze, [from], 0, %{})
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

  @doc "Sets from and to of a maze so that the path requires to connect the two is the longest path in the maze"
  def set_longest_path_from_and_to(maze) do
    {from, _} = find_max_vertex_by_distance(maze, {1, 1})
    {to, _} = find_max_vertex_by_distance(maze, from)
    %{maze | from: from, to: to}
  end

  @doc "Sets two random border vertices as from and to"
  def set_random_border_from_and_to(maze) do
    border_vertices = RectangularMaze.border_vertices(maze)
    [from, to | _] = Enum.shuffle(border_vertices)

    %{maze | from: from, to: to}
  end
end

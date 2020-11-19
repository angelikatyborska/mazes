defmodule Mazes.Maze do
  @type vertex :: {integer, integer}
  @type maze :: %{
          adjacency_matrix: %{vertex => %{vertex => boolean}},
          from: vertex,
          to: vertex,
          module: atom
        }

  @callback new(keyword) :: maze
  @callback center(maze) :: vertex

  @spec vertices(maze) :: [vertex]
  def vertices(maze) do
    Map.keys(maze.adjacency_matrix)
    |> Enum.sort(&sorter/2)
  end

  defp sorter({x1, y1}, {x2, y2}) do
    if y1 == y2 do
      x1 < x2
    else
      y1 < y2
    end
  end

  @doc "Returns all neighboring vertices that do not have a wall between themselves and the given one"
  @spec adjacent_vertices(maze, vertex) :: [vertex]
  def adjacent_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.filter(fn {_, adjacency} -> adjacency end)
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  @doc "Returns all neighboring vertices regardless of whether there is a wall or not"
  @spec neighboring_vertices(maze, vertex) :: [vertex]
  def neighboring_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  @doc "Groups vertices by the number of adjacent vertices they have"
  @spec group_vertices_by_adjacent_count(maze) :: %{integer => [vertex]}
  def group_vertices_by_adjacent_count(maze) do
    vertices(maze)
    |> Enum.group_by(fn vertex ->
      length(adjacent_vertices(maze, vertex))
    end)
  end

  @spec wall?(maze, vertex, vertex) :: boolean
  def wall?(maze, from, to), do: !maze.adjacency_matrix[from][to]

  @spec put_wall(maze, vertex, vertex) :: maze
  def put_wall(maze, from, to), do: set_adjacency(maze, from, to, false)

  @spec remove_wall(maze, vertex, vertex) :: maze
  def remove_wall(maze, from, to), do: set_adjacency(maze, from, to, true)

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end
end

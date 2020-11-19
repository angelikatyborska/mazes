defmodule Mazes.HexagonalMaze do
  @behaviour Mazes.Maze
  alias Mazes.Maze

  # hexes in the maze are arranged to have a flat top and bottom

  @impl true
  def new(opts) do
    width = Keyword.get(opts, :width)
    height = Keyword.get(opts, :height)
    all_vertices_adjacent? = Keyword.get(opts, :all_vertices_adjacent?, false)

    vertices =
      Enum.reduce(1..width, [], fn x, acc ->
        Enum.reduce(1..height, acc, fn y, acc2 ->
          [{x, y} | acc2]
        end)
      end)

    adjacency_matrix =
      vertices
      |> Enum.map(fn {from_x, from_y} = from ->
        value =
          vertices
          |> Enum.filter(fn {x, y} ->
            if Integer.mod(x, 2) == 1 do
              {x, y} in [
                {from_x, from_y - 1},
                {from_x - 1, from_y},
                {from_x + 1, from_y},
                {from_x - 1, from_y + 1},
                {from_x, from_y + 1},
                {from_x + 1, from_y + 1}
              ]
            else
              {x, y} in [
                {from_x - 1, from_y - 1},
                {from_x, from_y - 1},
                {from_x + 1, from_y - 1},
                {from_x - 1, from_y},
                {from_x + 1, from_y},
                {from_x, from_y + 1}
              ]
            end
          end)
          |> Enum.map(&{&1, all_vertices_adjacent?})
          |> Enum.into(%{})

        {from, value}
      end)
      |> Enum.into(%{})

    %Maze{
      width: width,
      height: height,
      adjacency_matrix: adjacency_matrix,
      module: __MODULE__
    }
  end

  @impl true
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
  @impl true
  def adjacent_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.filter(fn {_, adjacency} -> adjacency end)
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  @doc "Returns all neighboring vertices regardless of whether there is a wall or not"
  @impl true
  def neighboring_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end

  @doc "Groups vertices by the number of adjacent vertices they have"
  @impl true
  def group_vertices_by_adjacent_count(maze) do
    vertices(maze)
    |> Enum.group_by(fn vertex ->
      length(adjacent_vertices(maze, vertex))
    end)
  end

  @impl true
  def center(maze) do
    {trunc(Float.ceil(maze.width / 2)), trunc(Float.ceil(maze.height / 2))}
  end

  @impl true
  def wall?(%Maze{} = maze, from, to), do: !maze.adjacency_matrix[from][to]
  @impl true
  def put_wall(%Maze{} = maze, from, to), do: set_adjacency(maze, from, to, false)
  @impl true
  def remove_wall(%Maze{} = maze, from, to), do: set_adjacency(maze, from, to, true)

  # Not part of the behavior, functions needed for drawing the grid

  def north({x, y}), do: {x, y - 1}
  def south({x, y}), do: {x, y + 1}

  def northeast({x, y}) do
    if Integer.mod(x, 2) == 1 do
      {x + 1, y - 1}
    else
      {x + 1, y}
    end
  end

  def northwest({x, y}) do
    if Integer.mod(x, 2) == 1 do
      {x - 1, y - 1}
    else
      {x - 1, y}
    end
  end

  def southeast({x, y}) do
    if Integer.mod(x, 2) == 1 do
      {x + 1, y}
    else
      {x + 1, y + 1}
    end
  end

  def southwest({x, y}) do
    if Integer.mod(x, 2) == 1 do
      {x - 1, y}
    else
      {x - 1, y + 1}
    end
  end
end

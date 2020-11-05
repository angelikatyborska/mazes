defmodule Mazes.RectangularMaze do
  defstruct [:width, :height, :adjacency_matrix, :from, :to]

  @doc "Returns a rectangular maze with given size, either with all walls or no walls"
  def new(width, height, all_adjacent? \\ false, skip_from_and_to? \\ true) do
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
            {x, y} in [
              {from_x - 1, from_y},
              {from_x + 1, from_y},
              {from_x, from_y - 1},
              {from_x, from_y + 1}
            ]
          end)
          |> Enum.map(&{&1, all_adjacent?})
          |> Enum.into(%{})

        {from, value}
      end)
      |> Enum.into(%{})

    maze = %__MODULE__{
      width: width,
      height: height,
      adjacency_matrix: adjacency_matrix
    }
  end

  def map(maze, func) do
    Enum.map(1..maze.width, fn x ->
      Enum.map(1..maze.height, fn y ->
        func.({x, y})
      end)
    end)
  end

  def vertices(maze) do
    Map.keys(maze.adjacency_matrix)
  end

  def north({x, y}), do: {x, y - 1}
  def south({x, y}), do: {x, y + 1}
  def east({x, y}), do: {x + 1, y}
  def west({x, y}), do: {x - 1, y}

  def outer_wall?(%__MODULE__{} = _maze, {1, _}, {0, _}), do: true
  def outer_wall?(%__MODULE__{} = _maze, {_, 1}, {_, 0}), do: true

  def outer_wall?(%__MODULE__{} = maze, {x1, y1}, {x2, y2}) do
    (maze.width == x1 && x2 == x1 + 1) ||
      (maze.height == y1 && y2 == y1 + 1)
  end

  def wall?(%__MODULE__{} = maze, from, to), do: !maze.adjacency_matrix[from][to]
  def put_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, false)
  def remove_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, true)

  def adjacent_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.filter(fn {_, adjacency} -> adjacency end)
    |> Enum.map(fn {cell, _} -> cell end)
  end

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end

  def border_vertices(maze) do
    vertices = []

    vertices =
      Enum.reduce(1..maze.width, vertices, fn x, acc ->
        [{x, 1}, {x, maze.height} | acc]
      end)

    Enum.reduce(2..(maze.height - 1), vertices, fn y, acc ->
      [{1, y}, {maze.width, y} | acc]
    end)
  end
end

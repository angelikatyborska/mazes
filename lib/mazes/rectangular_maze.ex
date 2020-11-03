defmodule Mazes.RectangularMaze do
  defstruct [:width, :height, :adjacency_matrix]

  @doc "Returns a rectangular maze with given size, either with all walls or no walls"
  def new(width, height, all_adjacent? \\ false) do
    vertices =
      Enum.reduce(1..width, [], fn x, acc ->
        Enum.reduce(1..height, acc, fn y, acc2 ->
          [{x, y} | acc2]
        end)
      end)

    adjacency_matrix =
      vertices
      |> Enum.map(fn from ->
        value =
          vertices
          |> Enum.filter(&(&1 != from))
          |> Enum.map(&{&1, all_adjacent?})
          |> Enum.into(%{})

        {from, value}
      end)
      |> Enum.into(%{})

    %__MODULE__{
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

  def outer_wall?(%__MODULE__{} = _maze, _, {0, _}), do: true
  def outer_wall?(%__MODULE__{} = _maze, _, {_, 0}), do: true
  def outer_wall?(%__MODULE__{width: width} = _maze, {width, _}, {x2, _}), do: x2 == width + 1
  def outer_wall?(%__MODULE__{height: height} = _maze, {_, height}, {_, y2}), do: y2 == height + 1
  def outer_wall?(%__MODULE__{} = _maze, {_, _}, {_, _}), do: false

  def wall?(%__MODULE__{} = maze, from, to), do: !maze.adjacency_matrix[from][to]
  def put_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, false)
  def remove_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, true)

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end
end

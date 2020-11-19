defmodule Mazes.RectangularMaze do
  @behaviour Mazes.Maze

  @doc "Returns a rectangular maze with given size, either with all walls or no walls"
  @impl true
  def new(opts) do
    width = Keyword.get(opts, :width, 10)
    height = Keyword.get(opts, :height, 10)
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

  @impl true
  def center(maze) do
    {trunc(Float.ceil(maze.width / 2)), trunc(Float.ceil(maze.height / 2))}
  end

  # Not part of the behavior, functions needed for drawing the grid

  def north({x, y}), do: {x, y - 1}
  def south({x, y}), do: {x, y + 1}
  def east({x, y}), do: {x + 1, y}
  def west({x, y}), do: {x - 1, y}

  # Not part of the behavior, functions needed for the Binary Tree and Sidewinder algorithms

  def outer_wall?(_maze, {1, _}, {0, _}), do: true
  def outer_wall?(_maze, {_, 1}, {_, 0}), do: true

  def outer_wall?(maze, {x1, y1}, {x2, y2}) do
    (maze.width == x1 && x2 == x1 + 1) ||
      (maze.height == y1 && y2 == y1 + 1)
  end
end

defmodule Mazes.HexagonalMaze do
  @behaviour Mazes.Maze

  # hexes in the maze are arranged to have a flat top and bottom
  # the rows are zig-zag
  #  ___     ___
  # /1,1\___/3,1\___
  # \___/2,1\___/4,1\
  # /1,2\___/3,2\___/
  # \___/2,2\___/4,2\
  #     \___/   \___/

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

defmodule Mazes.TriangularMaze do
  @behaviour Mazes.Maze

  #  Triangles alternate base down / base up, starting with base down at 1,1
  #
  #      1,2_
  #    /\    /\
  #   /  \  /  \
  #  /1,1_\/1,3_\
  #  \ 2,1/\ 2,3/
  #   \  /  \  /
  #    \/_2,2\/

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
            if Integer.mod(from_x + from_y, 2) == 0 do
              {x, y} in [
                {from_x - 1, from_y},
                {from_x + 1, from_y},
                {from_x, from_y + 1}
              ]
            else
              {x, y} in [
                {from_x - 1, from_y},
                {from_x + 1, from_y},
                {from_x, from_y - 1}
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

  def north({x, y}) do
    if base_down?({x, y}) do
      nil
    else
      {x, y - 1}
    end
  end

  def south({x, y}) do
    if base_down?({x, y}) do
      {x, y + 1}
    else
      nil
    end
  end

  def east({x, y}), do: {x + 1, y}
  def west({x, y}), do: {x - 1, y}

  def base_down?({x, y}) do
    Integer.mod(x + y, 2) == 0
  end
end

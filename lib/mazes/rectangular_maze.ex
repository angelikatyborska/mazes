defmodule Mazes.RectangularMaze do
  defstruct [:width, :height, :adjacency_matrix]

  def new(width, height) do
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
          |> Enum.map(&{&1, false})
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
end

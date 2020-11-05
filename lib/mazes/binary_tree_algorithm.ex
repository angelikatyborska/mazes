defmodule Mazes.BinaryTreeAlgorithm do
  alias Mazes.RectangularMaze

  def generate(width, height) do
    maze = RectangularMaze.new(width, height)

    vertices =
      maze
      |> RectangularMaze.vertices()
      |> Enum.sort(fn {x1, y1}, {x2, y2} ->
        if x1 == x2 do
          y1 < y2
        else
          x1 < x2
        end
      end)

    do_generate(maze, vertices)
  end

  defp do_generate(maze, []) do
    maze
  end

  defp do_generate(maze, [vertex | vertices_to_visit]) do
    north = RectangularMaze.north(vertex)
    east = RectangularMaze.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!RectangularMaze.outer_wall?(maze, vertex, &1)))

    maze =
      case can_be_removed do
        [] ->
          maze

        list ->
          RectangularMaze.remove_wall(maze, vertex, Enum.random(list))
      end

    do_generate(maze, vertices_to_visit)
  end
end

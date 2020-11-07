defmodule Mazes.MazeGeneration.BinaryTreeAlgorithm do
  alias Mazes.RectangularMaze

  def generate(width, height) do
    maze = RectangularMaze.new(width, height)
    all_vertices = RectangularMaze.vertices(maze)

    do_generate(maze, all_vertices)
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

defmodule Mazes.MazeGeneration.BinaryTreeAlgorithm do
  @behaviour Mazes.MazeGeneration.Algorithm
  alias Mazes.RectangularMaze

  @impl true
  def supported_maze_types do
    [Mazes.RectangularMaze]
  end

  @impl true
  def generate(opts, module \\ RectangularMaze) do
    maze = module.new(opts)
    all_vertices = module.vertices(maze)

    do_generate(maze, all_vertices)
  end

  defp do_generate(maze, []) do
    maze
  end

  defp do_generate(maze, [vertex | vertices_to_visit]) do
    north = maze.module.north(vertex)
    east = maze.module.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!maze.module.outer_wall?(maze, vertex, &1)))

    maze =
      case can_be_removed do
        [] ->
          maze

        list ->
          maze.module.remove_wall(maze, vertex, Enum.random(list))
      end

    do_generate(maze, vertices_to_visit)
  end
end

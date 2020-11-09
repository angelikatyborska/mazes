defmodule Mazes.MazeGeneration.SidewinderAlgorithm do
  @behaviour Maze.MazeGeneration.Algorithm
  alias Mazes.RectangularMaze

  @impl true
  def supported_maze_types do
    [Mazes.RectangularMaze]
  end

  @impl true
  def generate(opts, module \\ RectangularMaze) do
    maze = module.new(opts)
    all_vertices = module.vertices(maze)

    do_generate(maze, all_vertices, [])
  end

  defp do_generate(maze, [], _) do
    maze
  end

  defp do_generate(maze, [vertex | vertices_to_visit], current_group) do
    north = maze.module.north(vertex)
    east = maze.module.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!maze.module.outer_wall?(maze, vertex, &1)))

    {maze, current_group} =
      case can_be_removed do
        [] ->
          {maze, []}

        list ->
          to_be_removed = Enum.random(list)

          case to_be_removed do
            ^east ->
              maze = maze.module.remove_wall(maze, vertex, east)
              {maze, [vertex | current_group]}

            ^north ->
              {remove_from, remove_to} =
                [vertex | current_group]
                |> Enum.map(&{&1, maze.module.north(&1)})
                |> Enum.random()

              maze = maze.module.remove_wall(maze, remove_from, remove_to)
              {maze, []}
          end
      end

    do_generate(maze, vertices_to_visit, current_group)
  end
end

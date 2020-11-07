defmodule Mazes.MazeGeneration.SidewinderAlgorithm do
  alias Mazes.RectangularMaze

  def generate(width, height) do
    maze = RectangularMaze.new(width, height)
    all_vertices = RectangularMaze.vertices(maze)

    do_generate(maze, all_vertices, [])
  end

  defp do_generate(maze, [], _) do
    maze
  end

  defp do_generate(maze, [vertex | vertices_to_visit], current_group) do
    north = RectangularMaze.north(vertex)
    east = RectangularMaze.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!RectangularMaze.outer_wall?(maze, vertex, &1)))

    {maze, current_group} =
      case can_be_removed do
        [] ->
          {maze, []}

        list ->
          to_be_removed = Enum.random(list)

          case to_be_removed do
            ^east ->
              maze = RectangularMaze.remove_wall(maze, vertex, east)
              {maze, [vertex | current_group]}

            ^north ->
              {remove_from, remove_to} =
                [vertex | current_group]
                |> Enum.map(&{&1, RectangularMaze.north(&1)})
                |> Enum.random()

              maze = RectangularMaze.remove_wall(maze, remove_from, remove_to)
              {maze, []}
          end
      end

    do_generate(maze, vertices_to_visit, current_group)
  end
end

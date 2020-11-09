defmodule Mazes.MazeGeneration.AldousBroderAlgorithm do
  @behaviour Maze.MazeGeneration.Algorithm
  alias Mazes.RectangularMaze

  @impl true
  def supported_maze_types do
    [Mazes.RectangularMaze, Mazes.RectangularMazeWithMask]
  end

  @impl true
  def generate(opts, module \\ RectangularMaze) do
    maze = module.new(opts)
    all_vertices = module.vertices(maze)

    visited =
      all_vertices
      |> Enum.map(&{&1, false})
      |> Enum.into(%{})

    start = Enum.random(all_vertices)

    visited = Map.put(visited, start, true)
    remaining = length(all_vertices) - 1

    do_generate(module, maze, start, visited, remaining)
  end

  defp do_generate(_, maze, _, _, 0) do
    maze
  end

  defp do_generate(module, maze, current_vertex, visited, remaining) do
    random_neighbor =
      maze
      |> module.neighboring_vertices(current_vertex)
      |> Enum.random()

    if visited[random_neighbor] do
      do_generate(module, maze, random_neighbor, visited, remaining)
    else
      maze = module.remove_wall(maze, current_vertex, random_neighbor)
      visited = Map.put(visited, random_neighbor, true)
      do_generate(module, maze, random_neighbor, visited, remaining - 1)
    end
  end
end

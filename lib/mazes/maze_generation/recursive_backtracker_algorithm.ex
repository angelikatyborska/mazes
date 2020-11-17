defmodule Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm do
  @behaviour Mazes.MazeGeneration.Algorithm
  alias Mazes.RectangularMaze

  @impl true
  def supported_maze_types do
    [Mazes.RectangularMaze, Mazes.RectangularMazeWithMask, Mazes.CircularMaze]
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

    do_generate(module, maze, [start], visited)
  end

  defp do_generate(_, maze, [], _) do
    maze
  end

  defp do_generate(module, maze, [current_vertex | stack_tail] = stack, visited) do
    unvisited_neighbors =
      maze
      |> module.neighboring_vertices(current_vertex)
      |> Enum.filter(&(!visited[&1]))

    if unvisited_neighbors == [] do
      do_generate(module, maze, stack_tail, visited)
    else
      next_vertex = Enum.random(unvisited_neighbors)
      maze = module.remove_wall(maze, current_vertex, next_vertex)
      visited = Map.put(visited, next_vertex, true)
      do_generate(module, maze, [next_vertex | stack], visited)
    end
  end
end

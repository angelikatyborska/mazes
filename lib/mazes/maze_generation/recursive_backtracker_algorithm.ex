defmodule Mazes.MazeGeneration.RecursiveBacktrackerAlgorithm do
  alias Mazes.RectangularMaze

  def generate(width, height) do
    maze = RectangularMaze.new(width, height)
    all_vertices = RectangularMaze.vertices(maze)

    visited =
      all_vertices
      |> Enum.map(&{&1, false})
      |> Enum.into(%{})

    start = Enum.random(all_vertices)
    visited = Map.put(visited, start, true)

    do_generate(maze, [start], visited)
  end

  defp do_generate(maze, [], _) do
    maze
  end

  defp do_generate(maze, [current_vertex | stack_tail] = stack, visited) do
    unvisited_neighbors =
      maze
      |> RectangularMaze.neighboring_vertices(current_vertex)
      |> Enum.filter(&(!visited[&1]))

    if unvisited_neighbors == [] do
      do_generate(maze, stack_tail, visited)
    else
      next_vertex = Enum.random(unvisited_neighbors)
      maze = RectangularMaze.remove_wall(maze, current_vertex, next_vertex)
      visited = Map.put(visited, next_vertex, true)
      do_generate(maze, [next_vertex | stack], visited)
    end
  end
end

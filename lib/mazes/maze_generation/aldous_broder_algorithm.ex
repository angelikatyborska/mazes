defmodule Mazes.MazeGeneration.AldousBroderAlgorithm do
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
    remaining = length(all_vertices) - 1

    do_generate(maze, start, visited, remaining)
  end

  defp do_generate(maze, _, _, 0) do
    maze
  end

  defp do_generate(maze, current_vertex, visited, remaining) do
    random_neighbor =
      maze
      |> RectangularMaze.neighboring_vertices(current_vertex)
      |> Enum.random()

    if visited[random_neighbor] do
      do_generate(maze, random_neighbor, visited, remaining)
    else
      maze = RectangularMaze.remove_wall(maze, current_vertex, random_neighbor)
      visited = Map.put(visited, random_neighbor, true)
      do_generate(maze, random_neighbor, visited, remaining - 1)
    end
  end
end

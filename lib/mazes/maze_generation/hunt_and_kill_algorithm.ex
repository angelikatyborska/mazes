defmodule Mazes.MazeGeneration.HuntAndKillAlgorithm do
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
    unvisited_neighbors =
      maze
      |> RectangularMaze.neighboring_vertices(current_vertex)
      |> Enum.filter(&(!visited[&1]))

    {from, next_vertex} =
      if unvisited_neighbors == [] do
        RectangularMaze.vertices(maze)
        |> Enum.find_value(fn vertex ->
          visited_neighbors =
            RectangularMaze.neighboring_vertices(maze, vertex)
            |> Enum.filter(&visited[&1])

          if !visited[vertex] && length(visited_neighbors) >= 1 do
            {Enum.random(visited_neighbors), vertex}
          else
            false
          end
        end)
      else
        {current_vertex, Enum.random(unvisited_neighbors)}
      end

    maze = RectangularMaze.remove_wall(maze, from, next_vertex)
    visited = Map.put(visited, next_vertex, true)
    do_generate(maze, next_vertex, visited, remaining - 1)
  end
end

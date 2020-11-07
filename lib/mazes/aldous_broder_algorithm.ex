defmodule Mazes.AldousBroderAlgorithm do
  alias Mazes.RectangularMaze

  def generate(width, height) do
    maze = RectangularMaze.new(width, height)

    all_vertices =
      maze
      |> RectangularMaze.vertices()
      |> Enum.sort(fn {x1, y1}, {x2, y2} ->
        if y1 == y2 do
          x1 < x2
        else
          y1 < y2
        end
      end)

    visited_map =
      all_vertices
      |> Enum.map(&{&1, false})
      |> Enum.into(%{})

    remaining = length(all_vertices)
    start = Enum.random(all_vertices)

    Map.put(visited_map, start, true)

    do_generate(maze, start, visited_map, remaining)
  end

  defp do_generate(maze, _, _, 0) do
    maze
  end

  defp do_generate(maze, current_vertex, visited_map, remaining) do
    random_neighbor =
      maze
      |> RectangularMaze.neighboring_vertices(current_vertex)
      |> Enum.random()

    if visited_map[random_neighbor] do
      do_generate(maze, random_neighbor, visited_map, remaining)
    else
      maze = RectangularMaze.remove_wall(maze, current_vertex, random_neighbor)
      visited_map = Map.put(visited_map, random_neighbor, true)
      do_generate(maze, random_neighbor, visited_map, remaining - 1)
    end
  end
end

defmodule Mazes.MazeGeneration.HuntAndKillAlgorithm do
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

    start = Enum.random(all_vertices)

    visited_map = Map.put(visited_map, start, true)
    remaining = length(all_vertices) - 1

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

    {from, next_vertex} =
      if visited_map[random_neighbor] do
        {vertex, _} =
          Enum.find_value(visited_map, fn {vertex, visited?} ->
            if visited? do
              unvisited_neighboring_vertices =
                RectangularMaze.neighboring_vertices(maze, vertex)
                |> Enum.filter(&(!visited_map[&1]))

              if unvisited_neighboring_vertices == [] do
                false
              else
                {vertex, hd(unvisited_neighboring_vertices)}
              end
            else
              false
            end
          end)
      else
        {current_vertex, random_neighbor}
      end

    maze = RectangularMaze.remove_wall(maze, from, next_vertex)
    visited_map = Map.put(visited_map, next_vertex, true)
    do_generate(maze, next_vertex, visited_map, remaining - 1)
  end
end

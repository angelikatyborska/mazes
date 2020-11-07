defmodule Mazes.WilsonsAlgorithm do
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

    do_generate(maze, [], visited_map, remaining)
  end

  defp do_generate(maze, _, _, 0) do
    maze
  end

  defp do_generate(maze, [], visited_map, remaining) do
    random_unvisited_vertex =
      visited_map
      |> Enum.filter(fn {_, visited?} -> !visited? end)
      |> Enum.map(fn {vertex, _} -> vertex end)
      |> Enum.random()

    do_generate(maze, [random_unvisited_vertex], visited_map, remaining)
  end

  defp do_generate(maze, [current_vertex | _] = current_path, visited_map, remaining) do
    random_neighbor = Enum.random(RectangularMaze.neighboring_vertices(maze, current_vertex))

    if visited_map[random_neighbor] do
      {maze, visited_map} =
        [random_neighbor | current_path]
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce({maze, visited_map}, fn [from, to], {maze, visited_map} ->
          maze = RectangularMaze.remove_wall(maze, from, to)
          visited_map = Map.put(visited_map, to, true)
          {maze, visited_map}
        end)

      remaining = remaining - length(current_path)
      do_generate(maze, [], visited_map, remaining)
    else
      current_path = [random_neighbor | maybe_remove_loop(current_path, random_neighbor, [])]
      do_generate(maze, current_path, visited_map, remaining)
    end
  end

  defp maybe_remove_loop([], _, acc), do: Enum.reverse(acc)
  defp maybe_remove_loop([h | t], h, _), do: maybe_remove_loop(t, h, [])
  defp maybe_remove_loop([h | t], x, acc), do: maybe_remove_loop(t, x, [h | acc])
end

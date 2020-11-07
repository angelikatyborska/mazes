defmodule Mazes.MazeGeneration.WilsonsAlgorithm do
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

    do_generate(maze, [], visited, remaining)
  end

  defp do_generate(maze, _, _, 0) do
    maze
  end

  defp do_generate(maze, [], visited, remaining) do
    random_unvisited_vertex =
      visited
      |> Enum.filter(fn {_, visited?} -> !visited? end)
      |> Enum.map(fn {vertex, _} -> vertex end)
      |> Enum.random()

    do_generate(maze, [random_unvisited_vertex], visited, remaining)
  end

  defp do_generate(maze, [current_vertex | _] = current_path, visited, remaining) do
    random_neighbor = Enum.random(RectangularMaze.neighboring_vertices(maze, current_vertex))

    if visited[random_neighbor] do
      {maze, visited} =
        [random_neighbor | current_path]
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce({maze, visited}, fn [from, to], {maze, visited} ->
          maze = RectangularMaze.remove_wall(maze, from, to)
          visited = Map.put(visited, to, true)
          {maze, visited}
        end)

      remaining = remaining - length(current_path)
      do_generate(maze, [], visited, remaining)
    else
      current_path = [random_neighbor | maybe_remove_loop(current_path, random_neighbor, [])]
      do_generate(maze, current_path, visited, remaining)
    end
  end

  defp maybe_remove_loop([], _, acc), do: Enum.reverse(acc)
  defp maybe_remove_loop([h | t], h, _), do: maybe_remove_loop(t, h, [])
  defp maybe_remove_loop([h | t], x, acc), do: maybe_remove_loop(t, x, [h | acc])
end

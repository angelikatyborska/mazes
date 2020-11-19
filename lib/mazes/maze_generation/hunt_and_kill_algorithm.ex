defmodule Mazes.MazeGeneration.HuntAndKillAlgorithm do
  @behaviour Mazes.MazeGeneration.Algorithm
  alias Mazes.Maze

  @impl true
  def supported_maze_types do
    [
      Mazes.RectangularMaze,
      Mazes.RectangularMazeWithMask,
      Mazes.CircularMaze,
      Mazes.HexagonalMaze
    ]
  end

  @impl true
  def generate(opts, module \\ Mazes.RectangularMaze) do
    maze = module.new(opts)
    all_vertices = Maze.vertices(maze)

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
    unvisited_neighbors =
      maze
      |> Maze.neighboring_vertices(current_vertex)
      |> Enum.filter(&(!visited[&1]))

    {from, next_vertex} =
      if unvisited_neighbors == [] do
        Maze.vertices(maze)
        |> Enum.find_value(fn vertex ->
          visited_neighbors =
            Maze.neighboring_vertices(maze, vertex)
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

    maze = Maze.remove_wall(maze, from, next_vertex)
    visited = Map.put(visited, next_vertex, true)
    do_generate(module, maze, next_vertex, visited, remaining - 1)
  end
end

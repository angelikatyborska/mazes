defmodule Mazes.MazeEntranceAndExit do
  alias Mazes.{MazeDistances, Maze}

  @doc "Sets from and to of a maze so that the path requires to connect the two is the longest path in the maze"
  def set_longest_path_from_and_to(maze) do
    {from, _} = MazeDistances.find_max_vertex_by_distance(maze, hd(Maze.vertices(maze)))
    {to, _} = MazeDistances.find_max_vertex_by_distance(maze, from)
    %{maze | from: from, to: to}
  end

  @doc "Sets two random vertices as from and to"
  def set_random_from_and_to(maze) do
    [from, to | _] = Enum.shuffle(Maze.vertices(maze))

    %{maze | from: from, to: to}
  end
end

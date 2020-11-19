defmodule Mazes.MazeGeneration.Algorithm do
  alias Mazes.Maze

  @callback supported_maze_types() :: [atom]
  @callback generate(keyword, atom) :: Maze.maze()
end

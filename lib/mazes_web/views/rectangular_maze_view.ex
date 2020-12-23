defmodule MazesWeb.RectangularMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.Maze

  def square_size(maze) do
    Integer.floor_div(max_svg_width(), Enum.max([maze.width, maze.height]))
  end
end

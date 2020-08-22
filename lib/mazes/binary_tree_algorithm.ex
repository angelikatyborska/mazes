defmodule Mazes.BinaryTreeAlgorithm do
  alias Mazes.RectangularMaze

  defstruct [:maze, :vertices_to_visit]

  def init(width, height) do
    maze = RectangularMaze.new(width, height)
    vertices = RectangularMaze.vertices(maze)

    %__MODULE__{
      maze: maze,
      vertices_to_visit: vertices
    }
  end

  def next_step(%__MODULE__{} = state) do
    %{maze: maze, vertices_to_visit: [vertex | vertices_to_visit]} = state
    north = RectangularMaze.north(vertex)
    east = RectangularMaze.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!RectangularMaze.outer_wall?(maze, vertex, &1)))

    maze =
      case can_be_removed do
        [] ->
          maze

        list ->
          RectangularMaze.remove_wall(maze, vertex, Enum.random(list))
      end

    state = %__MODULE__{maze: maze, vertices_to_visit: vertices_to_visit}

    case vertices_to_visit do
      [] -> {:halt, state}
      _ -> {:cont, state}
    end
  end
end

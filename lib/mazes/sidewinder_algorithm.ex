defmodule Mazes.SidewinderAlgorithm do
  alias Mazes.RectangularMaze

  defstruct [:maze, :vertices_to_visit, :current_group]

  def init(width, height) do
    maze = RectangularMaze.new(width, height)

    vertices =
      maze
      |> RectangularMaze.vertices()
      |> Enum.sort(fn {x1, y1}, {x2, y2} ->
        if y1 == y2 do
          x1 < x2
        else
          y1 < y2
        end
      end)

    %__MODULE__{
      maze: maze,
      vertices_to_visit: vertices,
      current_group: []
    }
  end

  def next_step(%__MODULE__{} = state) do
    %{maze: maze, vertices_to_visit: [vertex | vertices_to_visit], current_group: current_group} =
      state

    north = RectangularMaze.north(vertex)
    east = RectangularMaze.east(vertex)

    can_be_removed = Enum.filter([north, east], &(!RectangularMaze.outer_wall?(maze, vertex, &1)))

    {maze, current_group} =
      case can_be_removed do
        [] ->
          {maze, []}

        list ->
          to_be_removed = Enum.random(list)

          case to_be_removed do
            ^east ->
              maze = RectangularMaze.remove_wall(maze, vertex, east)
              {maze, [vertex | current_group]}

            ^north ->
              {remove_from, remove_to} =
                [vertex | current_group]
                |> Enum.map(&{&1, RectangularMaze.north(&1)})
                |> Enum.random()

              maze = RectangularMaze.remove_wall(maze, remove_from, remove_to)
              {maze, []}
          end
      end

    state = %__MODULE__{
      maze: maze,
      vertices_to_visit: vertices_to_visit,
      current_group: current_group
    }

    case vertices_to_visit do
      [] -> {:halt, state}
      _ -> {:cont, state}
    end
  end
end

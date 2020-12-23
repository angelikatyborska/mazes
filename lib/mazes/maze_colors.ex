defmodule Mazes.MazeColors do
  def color(distance, max_distance, hue \\ 0, saturation \\ 60) do
    # don't go down to 0 because the color will blend into the maze's walls
    min = 20
    max = 100
    lightness = max - trunc((max - min) * distance / max_distance)
    "hsl(#{hue}, #{saturation}%, #{lightness}%)"
  end

  def solution_color(hue \\ 0, saturation \\ 60) do
    "hsl(#{Integer.mod(hue + 180, 360)}, #{saturation}%, 50%)"
  end
end

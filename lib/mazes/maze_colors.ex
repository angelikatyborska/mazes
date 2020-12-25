defmodule Mazes.MazeColors do
  def color(distance, max_distance, hue, saturation \\ 60) do
    # don't go down to 0 because the color will blend into the maze's walls
    min = 20
    max = 100
    lightness = max - trunc((max - min) * distance / max_distance)
    "hsl(#{hue}, #{saturation}%, #{lightness}%)"
  end

  def color(hue, saturation \\ 60) do
    "hsl(#{hue}, #{saturation}%, 50%)"
  end
end

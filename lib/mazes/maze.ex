defmodule Mazes.Maze do
  defstruct [:width, :height, :adjacency_matrix, :from, :to, :module]

  @callback new(keyword) :: %__MODULE__{}
  @callback vertices(%__MODULE__{}) :: [{integer, integer}]
  @callback adjacent_vertices(%__MODULE__{}, {integer, integer}) :: [{integer, integer}]
  @callback neighboring_vertices(%__MODULE__{}, {integer, integer}) :: [{integer, integer}]
  @callback group_vertices_by_adjacent_count(%__MODULE__{}) :: %{}
  @callback center(%__MODULE__{}) :: {integer, integer}
  @callback wall?(%__MODULE__{}, {integer, integer}, {integer, integer}) :: boolean
  @callback put_wall(%__MODULE__{}, {integer, integer}, {integer, integer}) :: %__MODULE__{}
  @callback remove_wall(%__MODULE__{}, {integer, integer}, {integer, integer}) :: %__MODULE__{}
end

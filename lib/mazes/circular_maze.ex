defmodule Mazes.CircularMaze do
  @behaviour Mazes.Maze
  alias Mazes.Maze

  @doc "Returns a circular maze with given size, either with all walls or no walls"
  @impl true
  def new(opts) do
    radius = Keyword.get(opts, :radius, 10)
    first_ring_vertex_count = 8

    all_vertices_adjacent? = Keyword.get(opts, :all_vertices_adjacent?, false)

    # the adjacency_matrix of a circular maze is like a triangle, starting at the innermost ring
    # {1, 1}
    # -----------------------------
    # {1, 2}       <-> {2, 2}       <-> (loops back to {1, 2})
    # ------------- | -------------
    # {1, 3} <-> {2, 3} <-> {3, 3} <-> {3, 4}  <-> (loops back to {1, 3})
    # ------- | -------- | -------- | --------

    adjacency_matrix = %{{1, 1} => %{}}

    adjacency_matrix =
      do_new(
        2,
        radius,
        adjacency_matrix,
        1,
        first_ring_vertex_count,
        all_vertices_adjacent?
      )

    %{
      radius: radius,
      adjacency_matrix: adjacency_matrix,
      module: __MODULE__,
      from: nil,
      to: nil
    }
  end

  defp do_new(ring, max_rings, adjacency_matrix, _, _, _) when ring > max_rings do
    adjacency_matrix
  end

  # adjacency matrix has a triangle shape where first and last vertex in each row are neighbors
  defp do_new(
         ring,
         max_rings,
         adjacency_matrix,
         previous_ring_vertex_count,
         current_ring_vertex_count_growth,
         all_vertices_adjacent?
       ) do
    current_ring_vertex_count = previous_ring_vertex_count * current_ring_vertex_count_growth
    current_ring_columns = Enum.to_list(1..current_ring_vertex_count)

    next_ring_vertex_count_growth = get_next_right_vertex_count_growth(ring + 1)

    adjacency_matrix =
      [current_ring_vertex_count | current_ring_columns]
      |> Enum.chunk_every(3, 1, [1])
      |> Enum.reduce(adjacency_matrix, fn [ccw, x, cw], adjacency_matrix_acc ->
        current_vertex = {x, ring}

        previous_row_neighbor =
          {trunc(Float.ceil(x / current_ring_vertex_count_growth)), ring - 1}

        adjacency_matrix_acc =
          Map.update!(
            adjacency_matrix_acc,
            previous_row_neighbor,
            &Map.put(&1, current_vertex, all_vertices_adjacent?)
          )

        ccw_neighbor = {ccw, ring}
        cw_neighbor = {cw, ring}
        neighbors = [ccw_neighbor, cw_neighbor, previous_row_neighbor]
        adjacency_map = Enum.map(neighbors, &{&1, all_vertices_adjacent?}) |> Enum.into(%{})
        Map.put(adjacency_matrix_acc, current_vertex, adjacency_map)
      end)

    do_new(
      ring + 1,
      max_rings,
      adjacency_matrix,
      current_ring_vertex_count,
      next_ring_vertex_count_growth,
      all_vertices_adjacent?
    )
  end

  defp get_next_right_vertex_count_growth(ring, next_growth_at_ring \\ 3, delta \\ 2) do
    if ring == next_growth_at_ring do
      2
    else
      if ring >= next_growth_at_ring + delta do
        get_next_right_vertex_count_growth(ring, next_growth_at_ring * delta, delta)
      else
        1
      end
    end
  end

  @impl true
  def center(_) do
    {1, 1}
  end

  # Not part of the behavior, functions needed for drawing the grid

  def rings(maze) do
    Maze.vertices(maze)
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.map(fn {ring, vertices} ->
      %{ring: ring, column_count: length(vertices), vertices: vertices}
    end)
  end

  def inner(maze, {_, y} = vertex),
    do: Enum.find(Maze.neighboring_vertices(maze, vertex), &(elem(&1, 1) == y - 1))

  def cw(maze, {x, y} = vertex) do
    Enum.find(Maze.neighboring_vertices(maze, vertex), &(&1 == {x + 1, y})) ||
      Enum.find(Maze.neighboring_vertices(maze, vertex), &(&1 == {1, y}))
  end
end

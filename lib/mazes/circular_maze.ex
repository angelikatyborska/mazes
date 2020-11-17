defmodule Mazes.CircularMaze do
  @behaviour Mazes.Maze
  alias Mazes.Maze

  @doc "Returns a circular maze with given size, either with all walls or no walls"
  @impl true
  def new(opts) do
    rings = Keyword.get(opts, :rings)
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
        rings,
        adjacency_matrix,
        1,
        first_ring_vertex_count,
        all_vertices_adjacent?
      )

    %Maze{
      width: rings,
      height: rings,
      adjacency_matrix: adjacency_matrix,
      module: __MODULE__
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

  defp get_next_right_vertex_count_growth(ring, x \\ 3, delta \\ 2) do
    if ring == x do
      2
    else
      if ring >= x + delta do
        get_next_right_vertex_count_growth(ring, x * delta, delta)
      else
        1
      end
    end
  end

  @impl true
  def vertices(maze) do
    Map.keys(maze.adjacency_matrix)
    |> Enum.sort(&sorter/2)
  end

  defp sorter({x1, y1}, {x2, y2}) do
    if y1 == y2 do
      x1 < x2
    else
      y1 < y2
    end
  end

  @doc "Returns all neighboring vertices that do not have a wall between themselves and the given one"
  @impl true
  def adjacent_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.filter(fn {_, adjacency} -> adjacency end)
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  @doc "Returns all neighboring vertices regardless of whether there is a wall or not"
  @impl true
  def neighboring_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.map(fn {cell, _} -> cell end)
    |> Enum.sort(&sorter/2)
  end

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end

  @doc "Groups vertices by the number of adjacent vertices they have"
  @impl true
  def group_vertices_by_adjacent_count(maze) do
    vertices(maze)
    |> Enum.group_by(fn vertex ->
      length(adjacent_vertices(maze, vertex))
    end)
  end

  @impl true
  def center(_) do
    {1, 1}
  end

  @impl true
  def wall?(%Maze{} = maze, from, to), do: !maze.adjacency_matrix[from][to]
  @impl true
  def put_wall(%Maze{} = maze, from, to), do: set_adjacency(maze, from, to, false)
  @impl true
  def remove_wall(%Maze{} = maze, from, to), do: set_adjacency(maze, from, to, true)

  # Not part of the behavior, functions needed for drawing the grid

  def rings(maze) do
    vertices(maze)
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.map(fn {ring, vertices} ->
      %{ring: ring, column_count: length(vertices), vertices: vertices}
    end)
  end

  def inner(maze, {_, y} = vertex),
    do: Enum.find(neighboring_vertices(maze, vertex), &(elem(&1, 1) == y - 1))

  def cw(maze, {x, y} = vertex) do
    Enum.find(neighboring_vertices(maze, vertex), &(&1 == {x + 1, y})) ||
      Enum.find(neighboring_vertices(maze, vertex), &(&1 == {1, y}))
  end
end

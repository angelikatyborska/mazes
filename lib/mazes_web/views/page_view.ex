defmodule MazesWeb.PageView do
  use MazesWeb, :view

  alias Mazes.Settings

  def opts_for_shape_select() do
    labels = %{
      "rectangle" => "Rectangle",
      "rectangle-with-mask" => "Rectangle with a mask",
      "circle" => "Circle",
      "hex" => "Hex"
    }

    Enum.map(Settings.shapes(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_algorithm_select do
    labels = %{
      "algorithm-aldous-broder" => "Aldous-Broder (unbiased)",
      "algorithm-wilsons" => "Wilson's (unbiased)",
      "algorithm-hunt-and-kill" => "Hunt and Kill (biased)",
      "algorithm-recursive-backtracker" => "Recursive Backtracker (biased)",
      "algorithm-binary-tree" => "Binary Tree (biased)",
      "algorithm-sidewinder" => "Sidewinder (biased)"
    }

    Enum.map(Settings.algorithms(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_entrance_exit_strategy_select do
    labels = %{
      "entrance-exit-hardest" => "Longest path",
      "entrance-exit-random" => "Random",
      "entrance-exit-nil" => "None"
    }

    Enum.map(Settings.entrance_exit_strategies(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_mask_select() do
    opts = %{
      "heart" => %{emoji: "❤️", label: "Heart", width: 32},
      "star" => %{emoji: "⭐️", label: "Star", width: 32},
      "puzzle" => %{emoji: "🧩", label: "Puzzle", width: 32},
      "amazing" => %{emoji: "🔤", label: "A*maze*ing!", width: 64}
    }

    Enum.map(Settings.mask_files(), &Map.merge(&1, opts[&1.slug]))
  end

  def algorithm_disabled?(shape, algorithm) do
    if algorithm in Settings.algorithms_per_shape()[shape] do
      ""
    else
      "disabled"
    end
  end
end

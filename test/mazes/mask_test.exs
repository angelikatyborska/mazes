defmodule Mazes.MaskTest do
  use ExUnit.Case
  alias Mazes.Mask

  describe "validate_mask" do
    test "valid mask" do
      result = Mask.validate_mask("./test/fixtures/stairs.png")
      assert result == :ok
    end

    test "too many pixels" do
      result = Mask.validate_mask("./test/fixtures/too-big.png")

      assert result ==
               {:error, "Expected file to have no more than 4096 pixels, got 10000 (100 x 100)"}
    end

    test "two or more separate shapes" do
      result = Mask.validate_mask("./test/fixtures/two-separate-squares.png")
      assert result == {:error, "All black pixels have to form a single unbroken shape."}
    end
  end
end

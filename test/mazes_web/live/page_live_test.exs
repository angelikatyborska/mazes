defmodule MazesWeb.PageLiveTest do
  use MazesWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _page_live, _disconnected_html} = live(conn, "/")
  end
end

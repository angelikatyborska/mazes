defmodule MazesWeb.PageLiveTest do
  use MazesWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected render", %{conn: conn} do
    conn = get(conn, "/")

    conn
    |> html_response(200)
    |> assert_valid_html()
  end
end

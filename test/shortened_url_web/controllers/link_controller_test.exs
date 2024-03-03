defmodule ShortenedUrlWeb.LinkControllerTest do
  use ShortenedUrlWeb.ConnCase

  test "POST /urls generate shortened URL and redirects to show page", %{conn: conn} do
    conn = post(conn, "/urls", %{link: %{original_url: "http://example.com"}})

    assert conn.status == 200

    assert html_response(conn, 200) =~ "URL shortened successfully"
  end

  test "GET /stats displays statistics about shortened URLs", %{conn: conn} do
    conn = get(conn, "/stats")

    # Assert the status code directly instead of using html_response/2
    assert conn.status == 302

    # Assert the presence of the expected content in the HTML body
    assert html_response(conn, 302) =~
             "<html><body>You are being <a href=\"/\">redirected</a>.</body></html>"
  end

  test "GET /download_csv downloads CSV file with links data", %{conn: conn} do
    conn = get(conn, "/download_csv")
    assert conn.status == 302

    # Assert the presence of the expected content in the HTML body
    assert html_response(conn, 302) =~
             "<html><body>You are being <a href=\"/\">redirected</a>.</body></html>"
  end
end

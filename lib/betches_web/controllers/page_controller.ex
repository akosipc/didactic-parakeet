defmodule BetchesWeb.PageController do
  use BetchesWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

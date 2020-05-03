defmodule NameGameWeb.PageController do
  use NameGameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

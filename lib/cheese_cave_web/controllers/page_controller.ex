defmodule CheeseCaveWeb.PageController do
  use CheeseCaveWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
    # render(conn, :home, layout: false)
  end
end

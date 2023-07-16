defmodule CheeseCaveWeb.CheeseLive.Show do
  use CheeseCaveWeb, :live_view

  alias CheeseCave.Cheeses

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    IO.inspect(Cheeses.get_cheese!(id), label: "cheese")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cheese, Cheeses.get_cheese!(id))}
  end

  defp page_title(:show), do: "Show Cheese"
  defp page_title(:edit), do: "Edit Cheese"
end

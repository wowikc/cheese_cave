defmodule CheeseCaveWeb.CheeseLive.Index do
  use CheeseCaveWeb, :live_view

  alias CheeseCave.Cheeses
  alias CheeseCave.Cheeses.Cheese

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cheeses, Cheeses.list_cheeses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cheese")
    |> assign(:cheese, Cheeses.get_cheese!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cheese")
    |> assign(:cheese, %Cheese{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cheeses")
    |> assign(:cheese, nil)
  end

  @impl true
  def handle_info({CheeseCaveWeb.CheeseLive.FormComponent, {:saved, cheese}}, socket) do
    {:noreply, stream_insert(socket, :cheeses, cheese)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cheese = Cheeses.get_cheese!(id)
    {:ok, _} = Cheeses.delete_cheese(cheese)

    {:noreply, stream_delete(socket, :cheeses, cheese)}
  end
end

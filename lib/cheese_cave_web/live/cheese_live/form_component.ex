defmodule CheeseCaveWeb.CheeseLive.FormComponent do
  use CheeseCaveWeb, :live_component

  alias CheeseCave.Cheeses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage cheese records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="cheese-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:cheese_name]} type="text" label="Cheese name" />
        <.input field={@form[:press_done_date]} type="date" label="Press done date" />
        <.input field={@form[:start_aging_date]} type="date" label="Start aging date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Cheese</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{cheese: cheese} = assigns, socket) do
    changeset = Cheeses.change_cheese(cheese)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"cheese" => cheese_params}, socket) do
    changeset =
      socket.assigns.cheese
      |> Cheeses.change_cheese(cheese_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"cheese" => cheese_params}, socket) do
    save_cheese(socket, socket.assigns.action, cheese_params)
  end

  defp save_cheese(socket, :edit, cheese_params) do
    case Cheeses.update_cheese(socket.assigns.cheese, cheese_params) do
      {:ok, cheese} ->
        notify_parent({:saved, cheese})

        {:noreply,
         socket
         |> put_flash(:info, "Cheese updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_cheese(socket, :new, cheese_params) do
    case Cheeses.create_cheese(cheese_params) do
      {:ok, cheese} ->
        notify_parent({:saved, cheese})

        {:noreply,
         socket
         |> put_flash(:info, "Cheese created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

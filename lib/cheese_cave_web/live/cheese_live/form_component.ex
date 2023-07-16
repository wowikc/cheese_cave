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

      <form
        id="cheese-form"
        action={@action}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:cheese_name]} type="text" label="Cheese name" />
        <.input field={@form[:press_done_date]} type="date" label="Press done date" />
        <.input field={@form[:start_aging_date]} type="date" label="Start aging date" />

        <div class="container" phx-drop-target={@uploads.photos.ref}>
          <label>Photos</label>
          <div class="row m-0 mb-2">
            <%= for error <- upload_errors(@uploads.photos) do %>
              <div class="alert alert-danger">
                <%= error_to_string(error) %>
              </div>
            <% end %>
          </div>
          <div>
            <.live_file_input upload={@uploads.photos} />
          </div>
        </div>

        <section class="upload-entries">
          <h2>Preview</h2>
          <%= for entry <- @uploads.photos.entries do %>
            <p>
              <button
                type="button"
                phx-click="cancel-upload"
                phx-target={@myself}
                phx-value-ref={entry.ref}
              >
                &times;
              </button>
              <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
            </p>
            <.live_img_preview entry={entry} class="preview" />

            <p>Errors do not work for some reason :)</p>
            <div :for={err <- upload_errors(@uploads.photos, entry)} class="alert alert-danger">
              <%= error_to_string(err) %>
            </div>
          <% end %>
        </section>

        <.button type="submit" phx-disable-with="Saving...">Save cheese</.button>
      </form>
    </div>
    """
  end

  @impl true
  def update(%{cheese: cheese} = assigns, socket) do
    changeset = Cheeses.change_cheese(cheese)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:photos,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 2
     )}
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

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  defp save_cheese(socket, :edit, cheese_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :photos, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:cheese_cave), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    cheese_params = Map.put(cheese_params, "photos", uploaded_files)

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

  def error_to_string(:too_large), do: "image selected is too large"
  def error_to_string(:not_accepted), do: "unacceptable file type"
  def error_to_string(:too_many_files), do: "you have selected too many files"

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

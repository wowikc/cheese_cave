defmodule CheeseCave.Cheeses do
  @moduledoc """
  The Cheeses context.
  """

  import Ecto.Query, warn: false
  alias CheeseCave.Repo

  alias CheeseCave.Cheeses.Cheese

  @doc """
  Returns the list of cheeses.

  ## Examples

      iex> list_cheeses()
      [%Cheese{}, ...]

  """
  def list_cheeses do
    Repo.all(Cheese)
  end

  @doc """
  Gets a single cheese.

  Raises `Ecto.NoResultsError` if the Cheese does not exist.

  ## Examples

      iex> get_cheese!(123)
      %Cheese{}

      iex> get_cheese!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cheese!(id), do: Repo.get!(Cheese, id)

  @doc """
  Creates a cheese.

  ## Examples

      iex> create_cheese(%{field: value})
      {:ok, %Cheese{}}

      iex> create_cheese(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cheese(attrs \\ %{}) do
    %Cheese{}
    |> Cheese.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cheese.

  ## Examples

      iex> update_cheese(cheese, %{field: new_value})
      {:ok, %Cheese{}}

      iex> update_cheese(cheese, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cheese(%Cheese{} = cheese, attrs) do
    cheese
    |> Cheese.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cheese.

  ## Examples

      iex> delete_cheese(cheese)
      {:ok, %Cheese{}}

      iex> delete_cheese(cheese)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cheese(%Cheese{} = cheese) do
    Repo.delete(cheese)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cheese changes.

  ## Examples

      iex> change_cheese(cheese)
      %Ecto.Changeset{data: %Cheese{}}

  """
  def change_cheese(%Cheese{} = cheese, attrs \\ %{}) do
    Cheese.changeset(cheese, attrs)
  end
end

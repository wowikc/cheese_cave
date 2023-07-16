defmodule CheeseCave.CheesesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CheeseCave.Cheeses` context.
  """

  @doc """
  Generate a cheese.
  """
  def cheese_fixture(attrs \\ %{}) do
    {:ok, cheese} =
      attrs
      |> Enum.into(%{
        name: "some name",
        cheese_name: "some cheese_name",
        press_done_date: ~D[2023-07-15],
        start_aging_date: ~D[2023-07-15]
      })
      |> CheeseCave.Cheeses.create_cheese()

    cheese
  end
end

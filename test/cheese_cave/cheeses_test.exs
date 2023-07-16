defmodule CheeseCave.CheesesTest do
  use CheeseCave.DataCase

  alias CheeseCave.Cheeses

  describe "cheeses" do
    alias CheeseCave.Cheeses.Cheese

    import CheeseCave.CheesesFixtures

    @invalid_attrs %{name: nil, cheese_name: nil, press_done_date: nil, start_aging_date: nil}

    test "list_cheeses/0 returns all cheeses" do
      cheese = cheese_fixture()
      assert Cheeses.list_cheeses() == [cheese]
    end

    test "get_cheese!/1 returns the cheese with given id" do
      cheese = cheese_fixture()
      assert Cheeses.get_cheese!(cheese.id) == cheese
    end

    test "create_cheese/1 with valid data creates a cheese" do
      valid_attrs = %{name: "some name", cheese_name: "some cheese_name", press_done_date: ~D[2023-07-15], start_aging_date: ~D[2023-07-15]}

      assert {:ok, %Cheese{} = cheese} = Cheeses.create_cheese(valid_attrs)
      assert cheese.name == "some name"
      assert cheese.cheese_name == "some cheese_name"
      assert cheese.press_done_date == ~D[2023-07-15]
      assert cheese.start_aging_date == ~D[2023-07-15]
    end

    test "create_cheese/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cheeses.create_cheese(@invalid_attrs)
    end

    test "update_cheese/2 with valid data updates the cheese" do
      cheese = cheese_fixture()
      update_attrs = %{name: "some updated name", cheese_name: "some updated cheese_name", press_done_date: ~D[2023-07-16], start_aging_date: ~D[2023-07-16]}

      assert {:ok, %Cheese{} = cheese} = Cheeses.update_cheese(cheese, update_attrs)
      assert cheese.name == "some updated name"
      assert cheese.cheese_name == "some updated cheese_name"
      assert cheese.press_done_date == ~D[2023-07-16]
      assert cheese.start_aging_date == ~D[2023-07-16]
    end

    test "update_cheese/2 with invalid data returns error changeset" do
      cheese = cheese_fixture()
      assert {:error, %Ecto.Changeset{}} = Cheeses.update_cheese(cheese, @invalid_attrs)
      assert cheese == Cheeses.get_cheese!(cheese.id)
    end

    test "delete_cheese/1 deletes the cheese" do
      cheese = cheese_fixture()
      assert {:ok, %Cheese{}} = Cheeses.delete_cheese(cheese)
      assert_raise Ecto.NoResultsError, fn -> Cheeses.get_cheese!(cheese.id) end
    end

    test "change_cheese/1 returns a cheese changeset" do
      cheese = cheese_fixture()
      assert %Ecto.Changeset{} = Cheeses.change_cheese(cheese)
    end
  end
end

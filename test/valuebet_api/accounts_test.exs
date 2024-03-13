defmodule ValuebetApi.AccountsTest do
  use ValuebetApi.DataCase

  alias ValuebetApi.Accounts

  describe "users" do
    alias ValuebetApi.Accounts.User

    import ValuebetApi.AccountsFixtures

    @invalid_attrs %{
      status: nil,
      encrypted_password: nil,
      first_name: nil,
      last_name: nil,
      msisdn: nil,
      email: nil,
      deleted_at: nil
    }

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        status: true,
        encrypted_password: "some encrypted_password",
        first_name: "some first_name",
        last_name: "some last_name",
        msisdn: "some msisdn",
        email: "some email",
        deleted_at: ~U[2024-03-04 13:54:00Z]
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.status == true
      assert user.encrypted_password == "some encrypted_password"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.msisdn == "some msisdn"
      assert user.email == "some email"
      assert user.deleted_at == ~U[2024-03-04 13:54:00Z]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        status: false,
        encrypted_password: "some updated encrypted_password",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        msisdn: "some updated msisdn",
        email: "some updated email",
        deleted_at: ~U[2024-03-05 13:54:00Z]
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.status == false
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.msisdn == "some updated msisdn"
      assert user.email == "some updated email"
      assert user.deleted_at == ~U[2024-03-05 13:54:00Z]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "roles" do
    alias ValuebetApi.Accounts.Role

    import ValuebetApi.AccountsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Role{} = role} = Accounts.create_role(valid_attrs)
      assert role.name == "some name"
      assert role.description == "some description"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Role{} = role} = Accounts.update_role(role, update_attrs)
      assert role.name == "some updated name"
      assert role.description == "some updated description"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end

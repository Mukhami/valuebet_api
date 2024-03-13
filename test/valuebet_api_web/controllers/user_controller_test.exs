defmodule ValuebetApiWeb.UserControllerTest do
  use ValuebetApiWeb.ConnCase

  import ValuebetApi.AccountsFixtures

  alias ValuebetApi.Accounts.User

  @create_attrs %{
    status: true,
    encrypted_password: "some encrypted_password",
    first_name: "some first_name",
    last_name: "some last_name",
    msisdn: "some msisdn",
    email: "some email",
    deleted_at: ~U[2024-03-04 13:54:00Z]
  }
  @update_attrs %{
    status: false,
    encrypted_password: "some updated encrypted_password",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    msisdn: "some updated msisdn",
    email: "some updated email",
    deleted_at: ~U[2024-03-05 13:54:00Z]
  }
  @invalid_attrs %{
    status: nil,
    encrypted_password: nil,
    first_name: nil,
    last_name: nil,
    msisdn: nil,
    email: nil,
    deleted_at: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "deleted_at" => "2024-03-04T13:54:00Z",
               "email" => "some email",
               "encrypted_password" => "some encrypted_password",
               "first_name" => "some first_name",
               "last_name" => "some last_name",
               "msisdn" => "some msisdn",
               "status" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "deleted_at" => "2024-03-05T13:54:00Z",
               "email" => "some updated email",
               "encrypted_password" => "some updated encrypted_password",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name",
               "msisdn" => "some updated msisdn",
               "status" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end

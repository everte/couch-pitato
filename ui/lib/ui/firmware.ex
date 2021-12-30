defmodule Ui.Firmware do
  @moduledoc """
  The Firmware context.
  """

  import Ecto.Query, warn: false
  alias Ui.Repo

  alias Ui.Firmware.Button

  @doc """
  Returns the list of buttons.

  ## Examples

      iex> list_buttons()
      [%Button{}, ...]

  """
  def list_buttons do
    Repo.all(Button)
  end

  @doc """
  Gets a single button.

  Raises `Ecto.NoResultsError` if the Button does not exist.

  ## Examples

      iex> get_button!(123)
      %Button{}

      iex> get_button!(456)
      ** (Ecto.NoResultsError)

  """
  def get_button!(id), do: Repo.get!(Button, id)

  @doc """
  Creates a button.

  ## Examples

      iex> create_button(%{field: value})
      {:ok, %Button{}}

      iex> create_button(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_button(attrs \\ %{}) do
    %Button{}
    |> Button.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a button.

  ## Examples

      iex> update_button(button, %{field: new_value})
      {:ok, %Button{}}

      iex> update_button(button, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_button(%Button{} = button, attrs) do
    button
    |> Button.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a button.

  ## Examples

      iex> delete_button(button)
      {:ok, %Button{}}

      iex> delete_button(button)
      {:error, %Ecto.Changeset{}}

  """
  def delete_button(%Button{} = button) do
    Repo.delete(button)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking button changes.

  ## Examples

      iex> change_button(button)
      %Ecto.Changeset{data: %Button{}}

  """
  def change_button(%Button{} = button, attrs \\ %{}) do
    Button.changeset(button, attrs)
  end
end

defmodule Todo.Item do
  use Todo.Web, :model

  @type t :: %Todo.Item{
    id: non_neg_integer(),
    name: String.t(),

    completer: Todo.User.t() | nil,
    list: Todo.List.t(),

    inserted_at: Ecto.DateTime.t(),
    updated_at: Ecto.DateTime.t()
  }

  schema "items" do
    # ==========
    # Attributes
    # ==========

    field :name, :string

    timestamps()

    # ============
    # Associations
    # ============

    belongs_to :list, Todo.List
    belongs_to :completer, Todo.User
  end

  @allowed_fields ~W(name completer_id list_id)
  @required_fields ~W(name list_id)a

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(item, params) do
    item
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:completer)
    |> assoc_constraint(:list)
    |> unique_constraint(:name, name: :unique_name_within_list)
  end
end
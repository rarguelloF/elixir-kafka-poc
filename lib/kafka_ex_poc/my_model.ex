defmodule KafkaExPoc.MyModel do
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "my_models" do
    field(:num, :integer)
    field(:exq, :boolean, default: false)

    timestamps(type: :utc_datetime)
  end
end

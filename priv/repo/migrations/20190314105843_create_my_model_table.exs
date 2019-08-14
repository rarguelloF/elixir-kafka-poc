defmodule KafkaExPoc.Repo.Migrations.CreateMyModelTable do
  use Ecto.Migration

  def change do
    create table(:my_models, primary_key: false) do
      add(:id, :string, primary_key: true)
      add(:num, :integer)
      add(:exq, :boolean, default: false)

      timestamps(type: :utc_datetime)
    end
  end
end

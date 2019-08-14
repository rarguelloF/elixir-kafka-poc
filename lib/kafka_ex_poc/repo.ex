defmodule KafkaExPoc.Repo do
  use Ecto.Repo,
    otp_app: :kafka_ex_poc,
    adapter: Ecto.Adapters.Postgres
end

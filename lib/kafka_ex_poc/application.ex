defmodule KafkaExPoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      kafka_ex_consumer_group(),
      {KafkaExPoc.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaExPoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp kafka_ex_consumer_group do
    supervisor(
      KafkaEx.ConsumerGroup,
      [
        KafkaExPoc.Kafka.GenConsumer,
        "example_group",
        ["example_topic"],
        [
          # setting for the ConsumerGroup
          heartbeat_interval: 1_000,
          # this setting will be forwarded to the GenConsumer
          commit_interval: 1_000
        ]
      ]
    )
  end
end

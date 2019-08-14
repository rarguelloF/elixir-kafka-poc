# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :kafka_ex_poc,
  ecto_repos: [KafkaExPoc.Repo]

# See: https://github.com/kafkaex/kafka_ex/blob/master/config/config.exs
config :kafka_ex,
  # A list of brokers to connect to. This can be in either of the following formats
  #
  #  * [{"HOST", port}...]
  #  * CSV - `"HOST:PORT,HOST:PORT[,...]"`
  #  * {mod, fun, args}
  #  * &arity_zero_fun/0
  #  * fn -> ... end
  #
  # If you receive :leader_not_available
  # errors when producing messages, it may be necessary to modify "advertised.host.name" in the
  # server.properties file.
  # In the case below you would set "advertised.host.name=localhost"
  #
  # OR:
  # brokers: "localhost:9092,localhost:9093,localhost:9094"
  #
  # It may be useful to configure your brokers at runtime, for example if you use
  # service discovery instead of storing your broker hostnames in a config file.
  # To do this, you can use `{mod, fun, args}` or a zero-arity function, and `KafkaEx`
  # will invoke your callback when fetching the `:brokers` configuration.
  # Note that when using this approach you must return a list of host/port pairs.
  brokers: "localhost:9092",

  # the default consumer group for worker processes, must be a binary (string)
  #    NOTE if you are on Kafka < 0.8.2 or if you want to disable the use of
  #    consumer groups, set this to :no_consumer_group (this is the
  #    only exception to the requirement that this value be a binary)
  consumer_group: "kafka_ex_poc",

  # Set this value to true if you do not want the default
  # `KafkaEx.Server` worker to start during application start-up -
  # i.e., if you want to start your own set of named workers
  disable_default_worker: false,

  # Timeout value, in msec, for synchronous operations (e.g., network calls).
  # If this value is greater than GenServer's default timeout of 5000, it will also
  # be used as the timeout for work dispatched via KafkaEx.Server.call (e.g., KafkaEx.metadata).
  # In those cases, it should be considered a 'total timeout', encompassing both network calls and
  # wait time for the genservers.
  sync_timeout: 3000,

  # Supervision max_restarts - the maximum amount of restarts allowed in a time frame
  max_restarts: 10,

  # Supervision max_seconds -  the time frame in which :max_restarts applies
  max_seconds: 60,

  # Interval in milliseconds that GenConsumer waits to commit offsets.
  commit_interval: 5_000,
  commit_threshold: 100,
  use_ssl: false,
  kafka_version: "0.11.0"

config :kafka_ex_poc, KafkaExPoc.Repo,
  database: "ecto_simple",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432

# config :exq,
#   name: Exq,
#   start_on_application: false,
#   host: "localhost",
#   port: 6379,
#   namespace: "kafka_ex_poc_exq",
#   concurrency: 1000,
#   queues: ["default"],
#   poll_timeout: 50,
#   scheduler_poll_timeout: 200,
#   scheduler_enable: true,
#   max_retries: 25,
#   shutdown_timeout: 5000,
#   json_library: Jason,
#   dead_max_jobs: 10_000,
#   # 6 months
#   dead_timeout_in_seconds: 180 * 24 * 60 * 60

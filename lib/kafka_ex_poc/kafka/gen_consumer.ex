defmodule KafkaExPoc.Kafka.GenConsumer do
  require Logger

  use KafkaEx.GenConsumer

  alias KafkaExPoc.Kafka.Processor

  # note - messages are delivered in batches
  @spec handle_message_set(any(), any()) :: {:async_commit, any()}
  def handle_message_set(message_set, state) do
    case Processor.process_messages(message_set) do
      :ok -> {:async_commit, state}
      {:error, reason} -> raise "An error happened: #{inspect(reason)}"
    end
  end

  @impl true
  def handle_info({:EXIT, _pid, :normal}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:EXIT, _pid, error}, state) do
    Logger.error(fn -> "GenConsumer exited with error -> #{inspect(error)}" end)
    {:noreply, state}
  end
end

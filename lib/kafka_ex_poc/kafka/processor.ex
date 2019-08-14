defmodule KafkaExPoc.Kafka.Processor do
  require Logger

  alias KafkaEx.Protocol.Fetch.Message

  alias KafkaExPoc.Repo
  alias KafkaExPoc.MyModel

  @spec process_messages(any()) :: :ok | {:error, any()}
  def process_messages(message_set) do
    Logger.info(fn -> "Processing a batch of #{length(message_set)} messages" end)

    tasks = [
      Task.async(fn ->
        update_postgres_state(message_set)
      end),
      Task.async(fn ->
        enqueue_exq_jobs(message_set)
      end)
    ]

    results =
      Enum.map(Task.yield_many(tasks, 20000), fn {task, res} ->
        # Shut down the tasks that did not reply nor exit
        res || Task.shutdown(task, :brutal_kill)
      end)

    Logger.info(fn -> "Finished processing batch of #{length(message_set)} messages" end)

    case results do
      [{:ok, :ok}, {:ok, :ok}] ->
        :ok

      _ ->
        {:error, "job failed"}
    end
  end

  defp update_postgres_state(message_set) do
    Logger.info(fn -> "update_postgres_state" end)

    attrs = build_query_attrs(message_set)

    {_num_upserted, _models} =
      Repo.insert_all(MyModel, attrs,
        returning: true,
        on_conflict: {:replace, [:num, :exq, :updated_at]},
        conflict_target: [:id]
      )

    :ok
  end

  defp build_query_attrs(message_set) do
    timestamp = now()

    message_set
    |> Enum.map(fn %Message{value: message} -> Poison.decode!(message) end)
    |> Enum.group_by(&Map.get(&1, "id"))
    # [A -> [{a: 2},{b: 3},{a: 4} -> {a: 4, b: 3}], B -> [1,2,3], C-> [1,2,3]]
    |> Enum.map(fn {_id, upserts} ->
      Enum.reduce(upserts, %{}, fn elem, acc -> Map.merge(acc, elem) end)
    end)
    # [A -> [{a: 2},{b: 3},{a: 4} -> {a: 4, b: 3}], B -> [1,2,3], C-> [1,2,3]]
    |> Enum.map(&Map.new(&1, fn {k, v} -> {String.to_atom(k), v} end))
    |> Enum.map(&Map.put(&1, :inserted_at, timestamp))
    |> Enum.map(&Map.put(&1, :updated_at, timestamp))
  end

  defp now do
    DateTime.truncate(DateTime.utc_now(), :second)
  end

  defp enqueue_exq_jobs(message_set) do
    Logger.info(fn -> "enqueue_exq_jobs" end)
    :timer.sleep(:rand.uniform(10) * 1000)
    :ok
  end
end

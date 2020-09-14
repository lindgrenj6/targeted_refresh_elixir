defmodule TargetedRefresh do
  @query """
  select
    tasks.source_id,
    sources.uid as source_uid,
    tasks.id,
    tasks.target_source_ref,
    tasks.forwardable_headers
  from
    "tasks"
  inner join "sources" on
    "sources"."id" = "tasks"."source_id"
  where
    "tasks"."state" = 'running'
    and "tasks"."target_type" = 'ServiceInstance'
  order by
    source_id;
  """

  alias TargetedRefresh.{Db, Kafka}

  def main do
    Db.query(@query).rows
    |> Enum.map(&create_payload(&1))
    |> Enum.map(&Jason.encode!(&1))
    |> Enum.map(&Kafka.send(&1))
    |> Enum.all?(&(&1 == :ok))
  end

  defp create_payload(row) do
    %{
      "source_id" => Enum.at(row, 0),
      "source_uid" => Enum.at(row, 1),
      "params" => %{
        "task_id" => Enum.at(row, 2),
        "source_ref" => Enum.at(row, 3),
        "request_context" => Enum.at(row, 4)
      }
    }
  end
end

defmodule TargetedRefresh.Kafka do
  def send(msg) do
    KafkaEx.produce(
      "platform.topological-inventory.collector-ansible-tower",
      0,
      msg
    )
  end
end

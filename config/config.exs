use Mix.Config

config :kafka_ex,
  brokers: "10.0.0.15:9092",
  consumer_group: "kafka_ex"

env_config = Path.expand("#{Mix.env()}.exs", __DIR__)
if File.exists?(env_config) do
  import_config(env_config)
end

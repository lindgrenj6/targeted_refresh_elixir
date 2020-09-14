defmodule TargetedRefresh.Db do
  defp connect do
    Postgrex.start_link(
      hostname: "10.0.0.15",
      username: "root",
      password: "toor",
      database: "topological_inventory_development"
    )
  end

  def query(sql) do
    {:ok, pid} = connect()

    Postgrex.query!(pid, sql, [])
  end
end

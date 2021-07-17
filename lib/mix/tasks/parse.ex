defmodule Mix.Tasks.Parse do
  @moduledoc "Extracts App User IDs from RevenueCat customer lists"
  @requirements "app.config"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    args
    |> hd()
    |> CustomerListParser.extract_app_user_ids()
    |> CustomerListParser.generate_where_clause()
    |> IO.puts()
  end
end

defmodule Mix.Tasks.Parse do
  @moduledoc "Extracts App User IDs from RevenueCat customer lists"
  @requirements "app.config"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case args do
      [] ->
        CustomerListParser.extract_app_user_ids_from_stdin()

      ["-f" | rest] ->
        path_to_file = hd(rest)

        CustomerListParser.extract_app_user_ids_from_file(path_to_file)
    end
    |> CustomerListParser.generate_where_clause()
    |> IO.puts()
  end
end

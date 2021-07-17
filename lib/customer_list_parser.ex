defmodule CustomerListParser do
  @moduledoc """
  Functions for parsing customer lists exported by the [RevenueCat](https://www.revenuecat.com/) service.

  The exported customer lists are gzipped CSV files.
  For security reasons, customers can only be identified by a so-called App User ID.
  Each App User ID is a UUID associated to some record stored outside of RevenueCat.
  This tool extracts these UUIDs.
  """

  @doc """
  Extracts all (non-anonymous) App User IDs from the given (gzipped) CSV file.

  Note: the CSV files always use a semi-colon as the separator.
  """
  def extract_app_user_ids_from_file(path_to_file) when is_binary(path_to_file) do
    path_to_file |> File.read!() |> :zlib.gunzip() |> extract_app_user_ids()
  end

  def extract_app_user_ids_from_stdin() do
    IO.read(:all) |> extract_app_user_ids()
  end

  def extract_app_user_ids(string) when is_binary(string) do
    {:ok, pid} = string |> StringIO.open()

    app_user_ids =
      pid
      |> IO.binstream(:line)
      |> CSV.decode(separator: ?;, headers: true)
      |> Enum.filter(fn {result, row} ->
        if result !== :ok do
          IO.puts(:stderr, row)
        end

        result === :ok
      end)
      |> Enum.map(fn {:ok, row} -> row["app_user_id"] end)
      |> Enum.filter(fn app_user_id -> not String.starts_with?(app_user_id, "$RCAnonymousID") end)

    count = app_user_ids |> Enum.count()
    uniq_count = app_user_ids |> Enum.uniq() |> Enum.count()
    duplicates = app_user_ids -- Enum.uniq(app_user_ids)

    IO.puts(:stderr, "Extracted #{count} (#{uniq_count} unique) App User IDs")

    if not Enum.empty?(duplicates) do
      IO.puts(:stderr, "Duplicate App User IDs: #{duplicates}")
    end

    app_user_ids
  end

  @doc ~S"""
  Generates a string that serves as a value in a SQL `WHERE` `IN` clause.

  ## Examples

      iex> CustomerListParser.generate_where_clause(["Apple", "Banana", "Carrot"])
      "(\n'Apple',\n'Banana',\n'Carrot'\n)"
  """
  def generate_where_clause(app_user_ids) when is_list(app_user_ids) do
    string =
      app_user_ids |> Enum.map(fn app_user_id -> "'#{app_user_id}'" end) |> Enum.join(",\n")

    "(\n#{string}\n)"
  end
end

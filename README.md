# CustomerListParser

## Usage

### Docker
```
gunzip --to-stdout /path/to/file.csv.gz | docker run -i --rm parse
```

### Mix
```
mix parse -f /path/to/file.csv.gz
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `customer_list_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:customer_list_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/customer_list_parser](https://hexdocs.pm/customer_list_parser).


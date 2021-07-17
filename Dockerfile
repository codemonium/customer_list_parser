FROM elixir:1.11.4-alpine

WORKDIR /app

RUN mix local.hex --force

COPY . .

RUN mix deps.get && mix compile

ENTRYPOINT [ "/bin/sh", "-c" ]

CMD [ "mix parse" ]

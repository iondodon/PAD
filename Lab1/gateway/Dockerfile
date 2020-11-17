FROM elixir:1.9.4

COPY ./ /gateway
WORKDIR /gateway

RUN mix local.hex --force
RUN mix deps.get

CMD iex -S mix

EXPOSE 7171
FROM elixir:1.9.4

COPY ./ /cache
WORKDIR /cache

RUN mix deps.get

CMD iex -S mix

EXPOSE 6666
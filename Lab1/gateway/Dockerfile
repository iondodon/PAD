FROM elixir:1.9.4

COPY ./ /gateway
WORKDIR /gateway
EXPOSE 4000

RUN rm -rd _build
RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force

CMD iex -S mix
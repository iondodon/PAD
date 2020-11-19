FROM elixir:1.9.4

COPY ./ /cache-slave
WORKDIR /cache-slave

RUN mix deps.get

RUN apt-get update && apt-get install telnet

#CMD iex -S mix
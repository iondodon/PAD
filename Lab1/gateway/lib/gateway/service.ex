defmodule Gateway.Service do
  use HTTPoison.Base
  @endpoint "http://ruby:3000"

  def process_url(url) do
    @endpoint <> url
  end

  # def process_response_body(body) do
  #   body
  #   |> Poison.decode!
  #   |> Map.take(@expected_fields)
  #   |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  # end
end

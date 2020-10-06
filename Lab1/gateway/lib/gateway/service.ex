defmodule Gateway.Service do
  use HTTPoison.Base
  @endpoint "http://ruby:3000"

  def process_url(url) do
    @endpoint <> url
  end
end

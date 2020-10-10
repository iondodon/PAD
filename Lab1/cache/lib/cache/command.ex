defmodule Cache.Command do

    def parse(line) do
        case String.split(line) do
            ["CREATE", bucket] -> {:ok, {:create, bucket}}
            ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
            ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
            ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
            _ -> {:error, :unknown_command}
          end
    end

    @doc """
    Runs the given command.
    """
    def run(command)

    def run({:create, bucket}) do
        {:ok, "#{bucket}\r\n"}
    end
end
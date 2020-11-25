defmodule Utils do
    def parse_slave_response(response) do
        response = String.trim(response, " \r\n")
        case response do
            "(float) " <> value -> elem(Float.parse(value), 0)
            "(integer) " <> value -> elem(Integer.parse(value), 0)
            "(boolean) " <> value -> value
            "(atom) " <> value -> String.to_atom(value)
            "(binary) " <> value -> value
            "(function) " <> value -> value
            "(list) " <> values ->
                values = String.split(values)
                Enum.reduce(values, [], fn value, list ->
                    list ++ [value]
                end)
            "(tuple) " <> tuple -> tuple
            "(idunno) " <> _rest -> "idunno"
        end
    end

    def type_and_value(value) do
        value = internal_type(value)

        cond do
            is_float(value)    ->
                "(float) #{value}"
            is_integer(value)  ->
                "(integer) #{value}"
            is_boolean(value)  ->
                "(boolean) #{value}"
            is_atom(value)     ->
                "(atom) #{value}"
            is_binary(value)   ->
                "(binary) #{value}"
            is_function(value) ->
                "(function) #{value}"
            is_list(value)     ->
                value_str = Enum.reduce(value, "", fn item, str -> str <> " " <> item end)
                "(list) #{value_str}"
            is_tuple(value)    ->
                "(tuple) #{value}"
            true              ->
                "(idunno) #{value}"
        end
    end

    def internal_type(value) do
        if is_binary(value) do
            case Integer.parse(value) do
                {val, rem} -> if String.equivalent?(rem,"") do val else
                    {val, _rem} = Float.parse(value)
                    val
                end
                :error -> cond do
                    String.equivalent?(value, "true") -> true
                    String.equivalent?(value, "false") -> false
                    true -> value
                end
            end
        else
            value
        end
    end
end

defmodule Utils do
    def type_and_value(value) do
        cond do
            is_float(value)    -> "(float) #{value}"
            is_integer(value)  -> "(integer) #{value}"
            is_boolean(value)  -> "(boolean) #{value}"
            is_atom(value)     -> "(atom) #{value}"
            is_binary(value)   -> "(binary) #{value}"
            is_function(value) -> "(function) #{value}"
            is_list(value)     -> "(list) #{value}"
            is_tuple(value)    -> "(tuple) #{value}"
            true              -> "(idunno) #{value}"
        end    
    end

    def internal_type(str_value) do
        if is_binary(str_value) do
            case Integer.parse(str_value) do
                {val, rem} -> if String.equivalent?(rem,"") do val else
                    {val, _rem} = Float.parse(str_value)
                    val
                end
                :error -> cond do
                    String.equivalent?(str_value, "true") -> true
                    String.equivalent?(str_value, "false") -> false
                    true -> str_value
                end
            end
        else
            str_value
        end
    end
end
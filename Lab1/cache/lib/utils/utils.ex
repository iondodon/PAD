defmodule Utils do
    def type_and_value(value) do
        cond do
            is_float(value)    -> "(float)"
            is_integer(value)  -> "(integer)"
            is_atom(value)     -> "(atom)}"
            is_boolean(value)  -> "(boolean)"
            is_binary(value)   -> "(binary)"
            is_function(value) -> "(function)"
            is_list(value)     -> "(list)"
            is_tuple(value)    -> "(tuple)"
            true              -> "(idunno)"
        end    
    end
end
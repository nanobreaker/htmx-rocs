module [tokenize, Token]

Token : [Todo, Create, Get, Update, Delete, Argument Str, Title Str, Description Str, Start Str, End Str, Unknown]

tokenize : Str -> Result (List Token) [EmptyInput]
tokenize = |text|
    if
        Str.is_empty (Str.trim text) == Bool.true
    then
        Err EmptyInput
    else
        Str.split_on(text, " ")
        |> List.map |word| Str.to_utf8 word
        |> List.map |chars|
            when chars is
                ['t', 'o', 'd', 'o'] -> Todo
                ['c', 'r', 'e', 'a', 't', 'e'] -> Create
                ['g', 'e', 't'] -> Get
                ['u', 'p', 'd', 'a', 't', 'e'] -> Update
                ['d', 'e', 'l', 'e', 't', 'e'] -> Delete
                ['"', .. as value, '"'] -> Argument (Str.from_utf8_lossy value)
                ['-', 't', '"', .. as value, '"'] -> Title (Str.from_utf8_lossy value)
                ['-', 'd', '"', .. as value, '"'] -> Description (Str.from_utf8_lossy value)
                ['-', 's', '"', .. as value, '"'] -> Start (Str.from_utf8_lossy value)
                ['-', 'e', '"', .. as value, '"'] -> End (Str.from_utf8_lossy value)
                _ -> Unknown
        |> Ok

expect tokenize "" == Err EmptyInput
expect tokenize " " == Err EmptyInput
expect tokenize "todo" == Ok [Todo]
expect tokenize "test" == Ok [Unknown]
expect tokenize "todo create" == Ok [Todo, Create]

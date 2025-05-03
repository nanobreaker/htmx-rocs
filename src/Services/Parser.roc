module [parse]

Token : [Todo, Create, Argument Str, Description Str, Start Str, End Str, Unknown]

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
                ['"', .. as value, '"'] -> Argument (Str.from_utf8_lossy value)
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

parse : Str -> Result TodoCreate [EmptyInput, UnknownProgram, UnknownCommand, IncompleteCommand, FailedToParse]
parse = |text|
    tokens = tokenize(text)?

    when tokens is
        [] -> Err UnknownProgram
        [Todo, Create] -> Err IncompleteCommand
        [Todo, Create, ..] -> parse_todo_create(tokens)
        [_] -> Err UnknownProgram
        [_, ..] -> Err UnknownCommand

expect parse "" == Err EmptyInput
expect parse " " == Err EmptyInput
expect parse "test" == Err UnknownProgram
expect parse "test cruate" == Err UnknownCommand
expect parse "todo create" == Err IncompleteCommand
expect
    parse "todo create \"test\""
    == Ok { title: "test", description: None, start: None, end: None }
expect
    parse "todo create \"test\" -d\"desc\""
    == Ok { title: "test", description: Some "desc", start: None, end: None }
expect
    parse "todo create \"test\" -d\"desc\" -s\"10\" -e\"15\""
    == Ok { title: "test", description: Some "desc", start: Some "10", end: Some "15" }

TodoCreate : {
    title : Str,
    description : [None, Some Str],
    start : [None, Some Str],
    end : [None, Some Str],
}

parse_todo_create : List Token -> Result TodoCreate [FailedToParse]
parse_todo_create = |tokens|
    when tokens is
        [Todo, Create, Argument arg] ->
            Ok { title: arg, description: None, start: None, end: None }

        [Todo, Create, Argument arg, Description description] ->
            Ok { title: arg, description: Some description, start: None, end: None }

        [Todo, Create, Argument arg, Description description, Start start, End end] ->
            Ok { title: arg, description: Some description, start: Some start, end: Some end }

        _ -> Err FailedToParse


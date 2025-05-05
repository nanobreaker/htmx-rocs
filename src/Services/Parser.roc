module [parse]

import Services.Tokenizer exposing [tokenize, Token]

ParserErr : [EmptyInput, UnknownProgram, UnknownCommand, IncompleteCommand]

parse : Str -> Result _ ParserErr
parse = |text|
    when tokenize text is
        [] -> Err EmptyInput
        [Keyword Todo, Keyword Create] -> Err IncompleteCommand
        [Keyword Todo, Keyword Create, Text arg] ->
            Ok TodoCreate({ title: arg, description: None, start: None, end: None })

        [Keyword Todo, Keyword Create, Text arg, Option Description, Text description] ->
            Ok TodoCreate({ title: arg, description: Some description, start: None, end: None })

        [Keyword Todo, Keyword Create, Text arg, Option Description, Text description, Option Start, Text start, Option End, Text end] ->
            Ok TodoCreate({ title: arg, description: Some description, start: Some start, end: Some end })

        [Keyword Todo, Keyword Get, Text arg] ->
            Ok TodoGet({ title: arg })

        [Keyword Todo, Keyword Update, Text arg, Option Title, Text title, Option Description, Text description, Option Start, Text start, Option End, Text end] ->
            Ok TodoUpdate({ title: Some title, description: Some description, start: Some start, end: Some end })

        [Keyword Todo, Keyword Delete, Text arg] ->
            Ok TodoDelete({ title: arg })

        [_] -> Err UnknownProgram
        [_, ..] -> Err UnknownCommand

expect parse "" == Err EmptyInput
expect parse " " == Err EmptyInput
expect parse "test" == Err UnknownProgram
expect parse "test cruate" == Err UnknownCommand
expect parse "todo create" == Err IncompleteCommand
expect
    parse "todo create \"test\""
    == Ok TodoCreate({ title: "test", description: None, start: None, end: None })
expect
    parse "todo create \"test\" -d\"desc\""
    == Ok TodoCreate({ title: "test", description: Some "desc", start: None, end: None })
expect
    parse "todo create \"test\" -d\"desc\" -s\"10\" -e\"15\""
    == Ok TodoCreate({ title: "test", description: Some "desc", start: Some "10", end: Some "15" })


module [parse]

import Services.Tokenizer exposing [tokenize, Token]

ParserErr : [EmptyInput, UnknownProgram, UnknownCommand, IncompleteCommand]

parse : Str -> Result _ ParserErr
parse = |text|
    tokens = tokenize(text)?

    when tokens is
        [] -> Err UnknownProgram
        [Todo, Create] -> Err IncompleteCommand
        [Todo, Create, Argument arg] ->
            Ok TodoCreate({ title: arg, description: None, start: None, end: None })

        [Todo, Create, Argument arg, Description description] ->
            Ok TodoCreate({ title: arg, description: Some description, start: None, end: None })

        [Todo, Create, Argument arg, Description description, Start start, End end] ->
            Ok TodoCreate({ title: arg, description: Some description, start: Some start, end: Some end })

        [Todo, Get, Argument arg] ->
            Ok TodoGet({ title: arg })

        [Todo, Update, Title title, Description description, Start start, End end] ->
            Ok TodoUpdate({ title: Some title, description: Some description, start: Some start, end: Some end })

        [Todo, Delete, Argument arg] ->
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


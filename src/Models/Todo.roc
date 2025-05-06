module [Todo]

## Domain model to represent todo
## Minimal possible payload is just a Title
## Description, Start and End are optional fields
Todo : {
    title : Str,
    description : [Some Str, None],
    start : [Some Str, None],
    end : [Some Str, None],
}

module [tokenize, Token]

## Type alias to represent Token
Token : [
    Text Str,
    Keyword [Help, Todo, Create, Get, Update, Delete, Unknown Str],
    Option [Title, Description, Start, End, Unknown Str],
    Unknown Str,
]

## Type alias to represent state of the state machine
State : {
    state : [New, Keyword, Option, Text],
    tokens : List Token,
    acc : List U8,
}

## Tokenizes given input and produces list of tokens
## Returns empty list if no tokens found or input is empty
tokenize : Str -> List Token
tokenize = |text|
    List.walk (Str.to_utf8 text) { state: New, tokens: [], acc: [] } update
    |> finalize

# Inner function to update state of state maching while walking the list
update : State, U8 -> State
update = |state, char|
    when state.state is
        New ->
            when to_code char is
                Alphanumeric -> { state & state: Keyword, acc: [char] }
                Whitespace -> { state & state: New, acc: [] }
                QuotationMark -> { state & state: Text, acc: [] }
                Dash -> { state & state: Option, acc: [] }
                Unknown -> { state & state: New, acc: [] }

        Keyword ->
            when to_code char is
                Alphanumeric -> { state & state: Keyword, acc: List.append(state.acc, char) }
                _ -> { state: New, tokens: List.append(state.tokens, Keyword (to_keyword state.acc)), acc: [] }

        Option ->
            when to_code char is
                Whitespace -> state
                QuotationMark -> { state: Text, tokens: List.append(state.tokens, Option (to_option state.acc)), acc: [] }
                _ -> { state: Option, tokens: state.tokens, acc: List.append(state.acc, char) }

        Text ->
            when to_code char is
                QuotationMark -> { state: New, tokens: List.append(state.tokens, Text (Str.from_utf8_lossy state.acc)), acc: [] }
                _ -> { state: Text, tokens: state.tokens, acc: List.append(state.acc, char) }

## Finalize pending tokens and return list of tokens
finalize : State -> List Token
finalize = |state|
    when state.state is
        New -> state.tokens
        Keyword -> List.append state.tokens (Keyword (to_keyword state.acc))
        Option -> List.append state.tokens (Option (to_option state.acc))
        Text -> state.tokens

# Helper function to determine code based on char
to_code : U8 -> [Alphanumeric, Whitespace, QuotationMark, Dash, Unknown]
to_code = |char|
    if char > 64 and char < 122 then
        Alphanumeric
    else if char == ' ' then
        Whitespace
    else if char == '"' then
        QuotationMark
    else if char == '-' then
        Dash
    else
        Unknown

# Helper function to determine keyword based on accumulated chars
to_keyword : List U8 -> [Help, Todo, Create, Get, Update, Delete, Unknown Str]
to_keyword = |chars|
    when Str.from_utf8_lossy chars is
        "help" -> Help
        "todo" -> Todo
        "create" -> Create
        "get" -> Get
        "update" -> Update
        "delete" -> Delete
        _ -> Unknown (Str.from_utf8_lossy chars)

# Helper function to determine option based on accumulated chars
to_option : List U8 -> [Title, Description, Start, End, Unknown Str]
to_option = |chars|
    when chars is
        ['t'] -> Title
        ['d'] -> Description
        ['s'] -> Start
        ['e'] -> End
        _ -> Unknown (Str.from_utf8_lossy chars)

expect tokenize "" == []
expect tokenize " " == []
expect tokenize "todo" == [Keyword Todo]
expect tokenize "test" == [Keyword (Unknown "test")]
expect tokenize "todo get" == [Keyword Todo, Keyword Get]
expect tokenize "todo update" == [Keyword Todo, Keyword Update]
expect tokenize "todo delete" == [Keyword Todo, Keyword Delete]
expect tokenize "todo create" == [Keyword Todo, Keyword Create]
expect tokenize "todo create \"title\"" == [Keyword Todo, Keyword Create, Text "title"]
expect
    tokenize "todo create \"title\" -d\"test\""
    == [
        Keyword Todo,
        Keyword Create,
        Text "title",
        Option Description,
        Text "test",
    ]
expect
    tokenize "todo create \"title\" -d\"test\" -s\"01.01.2025\" -e\"01.01.2026\""
    == [
        Keyword Todo,
        Keyword Create,
        Text "title",
        Option Description,
        Text "test",
        Option Start,
        Text "01.01.2025",
        Option End,
        Text "01.01.2026",
    ]
expect
    tokenize "todo update \"title\" -t\"new title\" -d\"test\" -s\"01.01.2025\" -e\"01.01.2026\""
    == [
        Keyword Todo,
        Keyword Update,
        Text "title",
        Option Title,
        Text "new title",
        Option Description,
        Text "test",
        Option Start,
        Text "01.01.2025",
        Option End,
        Text "01.01.2026",
    ]

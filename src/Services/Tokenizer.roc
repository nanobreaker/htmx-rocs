module [tokenize, Token]

Token : [
    Text Str,
    Keyword [Help, Todo, Create, Get, Update, Delete, Unknown Str],
    Option [Title, Description, Start, End, Unknown Str],
    Unknown Str,
]

tokenize : Str -> List Token
tokenize = |text|
    Str.to_utf8 text
    |> List.append '|'
    |> List.walk { state: BeginToken, tokens: [], buffer: [] } |state, elem|
        when state.state is
            BeginToken ->
                when to_code elem is
                    LetterOrDigit -> { state & state: Keyword, buffer: [elem] }
                    Whitespace -> { state & state: BeginToken, buffer: [] }
                    QuotationMark -> { state & state: Text, buffer: [] }
                    Dash -> { state & state: Option, buffer: [] }
                    Unknown -> { state & state: BeginToken, buffer: [] }

            Keyword ->
                when to_code elem is
                    LetterOrDigit ->
                        { state &
                            state: Keyword,
                            buffer: List.append(state.buffer, elem),
                        }

                    _ ->
                        {
                            state: BeginToken,
                            tokens: List.append(state.tokens, Keyword (to_keyword state.buffer)),
                            buffer: [],
                        }

            Option ->
                when to_code elem is
                    Whitespace -> state
                    QuotationMark ->
                        {
                            state: Text,
                            tokens: List.append(state.tokens, Option (to_option state.buffer)),
                            buffer: [],
                        }

                    _ ->
                        {
                            state: Option,
                            tokens: state.tokens,
                            buffer: List.append(state.buffer, elem),
                        }

            Text ->
                when to_code elem is
                    QuotationMark ->
                        {
                            state: BeginToken,
                            tokens: List.append(state.tokens, Text (Str.from_utf8_lossy state.buffer)),
                            buffer: [],
                        }

                    _ ->
                        {
                            state: Text,
                            tokens: state.tokens,
                            buffer: List.append(state.buffer, elem),
                        }
    |> .tokens

to_code : U8 -> [LetterOrDigit, Whitespace, QuotationMark, Dash, Unknown]
to_code = |char|
    if char > 64 and char < 122 then
        LetterOrDigit
    else if char == ' ' then
        Whitespace
    else if char == '"' then
        QuotationMark
    else if char == '-' then
        Dash
    else
        Unknown

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

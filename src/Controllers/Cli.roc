module [handle!]

import ws.Http exposing [Request, Response]
import ws.Url
import ws.MultipartFormData
import ws.Stdout

import Services.Parser exposing [parse, Command, ParserErr]

CliError : [UnknownCommand, NotSupportedOperation, KeyNotFound, IOFailed]

handle! : Request => Result Response CliError
handle! = |req|
    url_segments =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url_segments) is
        (POST, ["cli"]) ->
            form = MultipartFormData.parse_form_url_encoded(req.body) ? |_| IOFailed
            text = Dict.get form "command" ? |_| KeyNotFound

            when parse text is
                Ok command ->
                    when handle_command! command is
                        Ok response -> Ok response
                        Err _ -> Err UnknownCommand

                Err _ -> Err UnknownCommand

        (_, _) -> Err NotSupportedOperation

handle_command! : Command => Result Response _
handle_command! = |command|
    when command is
        TodoCreate({ title, description, start, end }) ->
            Stdout.line!("${title}")?
            when description is
                Some text -> Stdout.line!("${text}")?
                None -> Stdout.line!("no description")?
            when start is
                Some text -> Stdout.line!("${text}")?
                None -> Stdout.line!("no start")?
            when end is
                Some text -> Stdout.line!("${text}")?
                None -> Stdout.line!("no end")?

            Ok { status: 200, headers: [], body: Str.to_utf8 "ok" }

        _ -> Ok { status: 200, headers: [], body: Str.to_utf8 "ok" }

module [handle!]

import ws.Http exposing [Request, Response]
import ws.Url
import ws.MultipartFormData

import Services.Parser

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

            when Services.Parser.parse text is
                Ok value ->
                    Ok {
                        status: 200,
                        headers: [],
                        body: Str.to_utf8 (Inspect.to_str value),
                    }

                Err err ->
                    Ok {
                        status: 400,
                        headers: [],
                        body: Str.to_utf8 (Inspect.to_str err),
                    }

        (_, _) -> Err NotSupportedOperation

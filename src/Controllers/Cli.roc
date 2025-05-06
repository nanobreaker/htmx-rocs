module [handle!]

import ws.Http exposing [Request, Response]
import ws.Url
import ws.MultipartFormData
import ws.Stdout

import Views.Todo exposing [page]
import Models.Todo exposing [Todo]
import Services.Parser exposing [parse, Command, ParserErr]
import Repositories.TodoRepository exposing [save!, find!]
import hasnep.Html

handle! : Request => Result Response _
handle! = |req|
    url_segments =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url_segments) is
        (POST, ["cli"]) ->
            MultipartFormData.parse_form_url_encoded(req.body)
            |> Result.try |form| Dict.get form "command"
            |> Result.try |txt| parse txt
            |> Result.try |cmd| handle_command cmd

        (_, _) ->
            Ok {
                status: 400,
                headers: [],
                body: Str.to_utf8 "not supported",
            }

handle_command : Command -> Result Response _
handle_command = |command|
    when command is
        TodoCreate(todo) ->
            save! todo "test.db" "1"
            |> Result.map_ok |t| page t
            |> Result.map_ok |html| Html.render html
            |> Result.map_ok |text| Str.to_utf8 text
            |> Result.map_ok |utf8| {
                status: 200,
                headers: [],
                body: utf8,
            }

        _ ->
            Ok {
                status: 400,
                headers: [],
                body: Str.to_utf8 "not supported",
            }

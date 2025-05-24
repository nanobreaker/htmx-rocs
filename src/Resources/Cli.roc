module [handle!]

import platform.Http exposing [Request, Response]
import platform.MultipartFormData
import template.Html

import Templates.Todo
import Repositories.Todo exposing [save!]
import Services.Parser exposing [parse, Command]

handle! : Request, List Str => Result Response [ServerErr Str]_
handle! = |req, url|
    when (req.method, url) is
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
            |> Result.map_ok |t| Templates.Todo.template t
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

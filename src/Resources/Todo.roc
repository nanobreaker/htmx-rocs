module [handle!]

import platform.Http exposing [Request, Response]
import platform.Url
import platform.MultipartFormData

import Models.Todo exposing [Todo]
import Repositories.Todo exposing [save!, find!]

TodoErr : [EmptyTitle, NotSupportedOperation, PersistFailed]

handle! : Request, List Str => Result Response [ServerErr Str]_
handle! = |req, url|
    when (req.method, url) is
        (POST, ["todo"]) ->
            MultipartFormData.parse_form_url_encoded req.body
            ? |_| PersistFailed
            |> create_todo?
            |> save! "test.db" "1"
            |> Result.map_ok |_| {
                status: 200,
                headers: [],
                body: Str.to_utf8 "test",
            }

        (_, _) -> Err NotSupportedOperation

create_todo : Dict Str Str -> Result Todo TodoErr
create_todo = |form|
    title =
        Dict.get form "title" ? |_| EmptyTitle

    description =
        Dict.get form "description"
        |> Result.map_ok |v| Some v
        |> Result.with_default None

    start =
        Dict.get form "start"
        |> Result.map_ok |v| Some v
        |> Result.with_default None

    end =
        Dict.get form "end"
        |> Result.map_ok |v| Some v
        |> Result.with_default None

    Ok { title, description, start, end }

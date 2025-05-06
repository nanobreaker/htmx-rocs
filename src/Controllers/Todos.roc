module [handle!]

import ws.Stdout
import ws.Http exposing [Request, Response]
import ws.Utc
import ws.Url
import ws.MultipartFormData
import time.DateTime as DT
import Models.Todo exposing [Todo]
import Repositories.TodoRepository exposing [save!, find!]

TodoErr : [EmptyTitle, NotSupportedOperation, PersistFailed]

handle! : Request => Result Response _
handle! = |req|
    url_segments =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url_segments) is
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

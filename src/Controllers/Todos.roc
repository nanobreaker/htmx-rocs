module [handle!]

import ws.Stdout
import ws.Http exposing [Request, Response]
import ws.Utc
import ws.Url
import time.DateTime as DT

Description : [None, Some Str]
Start : [None, Some Str]
End : [None, Some Str]
Todo : { title : Str, description : Description, start : Start, end : End }
TodoErr : [EmptyTitle, NotSupportedOperation, PersistFailed]

handle! : Request => Result Response TodoErr
handle! = |req|
    url_segments =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url_segments) is
        (POST, ["todo"]) ->
            todo =
                Str.from_utf8_lossy req.body
                |> parse_form_urlencoded
                |> create_todo?

            persist! todo
            |> Result.map_ok |_| {
                status: 200,
                headers: [],
                body: Str.to_utf8 "${todo.title}",
            }

        (_, _) -> Err NotSupportedOperation

create_todo : Dict Str Str -> Result Todo TodoErr
create_todo = |form|
    title_res = Dict.get(form, "title")
    description = parse_description form "description"
    start = parse_start form "start"
    end = parse_end form "end"

    when title_res is
        Ok title -> Ok { title, description, start, end }
        Err _ -> Err EmptyTitle

persist! : Todo => Result {} TodoErr
persist! = |todo|
    # todo: implement db connection
    Stdout.line! "persisting todo: ${todo.title}"
    |> Result.map_err |_| PersistFailed

parse_description : Dict Str Str, Str -> Description
parse_description = |dict, key|
    when Dict.get(dict, key) is
        Ok value -> Some value
        Err _ -> None

parse_start : Dict Str Str, Str -> Start
parse_start = |dict, key|
    when Dict.get(dict, key) is
        Ok value -> Some value
        Err _ -> None

parse_end : Dict Str Str, Str -> End
parse_end = |dict, key|
    when Dict.get(dict, key) is
        Ok value -> Some value
        Err _ -> None

parse_form_urlencoded : Str -> Dict Str Str
parse_form_urlencoded = |str|
    Str.split_on str "&"
    |> List.walk
        (Dict.empty {})
        |dict, pair|
            when Str.split_first pair "=" is
                Ok({ before, after }) -> Dict.insert(dict, before, after)
                Err(_) -> Dict.insert(dict, pair, "")

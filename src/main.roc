app [Model, init!, respond!] {
    platform: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.12.0/Q4h_In-sz1BqAvlpmCsBHhEJnn_YvfRRMiNACB_fBbk.tar.br",
    template: "https://github.com/Hasnep/roc-html/releases/download/v0.7.0/3uTKBUdKr7d017eneDe4CLgMB1FHlYSWe7vkC20a5fI.tar.br",
    time: "https://github.com/imclerran/roc-isodate/releases/download/v0.7.4/bEDedspHQApTvZI2GJfgXpzUmYO_ATw5d6xE_w1qcME.tar.br",
}

import "../web/scripts/main.js" as main_js_file : List U8
import "../web/styles/main.css" as main_css_file : List U8

import platform.Stdout
import platform.Http
import platform.Utc
import platform.Url

import Resources.Entry
import Resources.Register
import Resources.Login
import Resources.Dashboard
import Resources.Todo
import Resources.Cli

Model : {}

init! : {} => Result Model []
init! = |_| Ok {}

respond! : Http.Request, Model => Result Http.Response [ServerErr Str]_
respond! = |req, _|
    log!(req)?

    url =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url) is
        (GET, ["main.js"]) ->
            Ok {
                status: 200,
                headers: [{ name: "Cache-Control", value: "max-age=120" }],
                body: main_js_file,
            }

        (GET, ["main.css"]) ->
            Ok {
                status: 200,
                headers: [{ name: "Cache-Control", value: "max-age=120" }],
                body: main_css_file,
            }

        (_, [""]) ->
            Resources.Entry.handle req url

        (_, ["register"]) ->
            Resources.Register.handle! req url

        (_, ["login"]) ->
            Resources.Login.handle! req url

        (_, ["dashboard"]) ->
            Resources.Dashboard.handle! req url

        (_, ["todo"]) ->
            Resources.Todo.handle! req url

        (_, ["cli"]) ->
            Resources.Cli.handle! req url

        _ ->
            Ok {
                status: 404,
                headers: [],
                body: Str.to_utf8 "path not found: ${req.uri}",
            }

log! : Http.Request => Result {} [ServerErr Str]
log! = |req|
    datetime = Utc.to_iso_8601 (Utc.now! {})

    Stdout.line! "${datetime} ${Inspect.to_str req.method} ${req.uri}"
    |> Result.map_err |_| ServerErr "${datetime} Failed to log request"

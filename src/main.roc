app [Model, init!, respond!] {
    ws: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.12.0/Q4h_In-sz1BqAvlpmCsBHhEJnn_YvfRRMiNACB_fBbk.tar.br",
    hasnep: "https://github.com/Hasnep/roc-html/releases/download/v0.7.0/3uTKBUdKr7d017eneDe4CLgMB1FHlYSWe7vkC20a5fI.tar.br",
}

import ws.Stdout
import ws.Http exposing [Request, Response]
import ws.Utc
import ws.Url

import hasnep.Html exposing [h1, body, text]

import "../web/scripts/main.js" as main_js_file : List U8
import "../web/styles/main.css" as main_css_file : List U8

import Views.Login
import Views.Dashboard

Model : {}

init! : {} => Result Model []
init! = |_|
    Ok {}

respond! : Request, Model => Result Response [ServerErr Str]_
respond! = |req, _|
    try log_request! req

    url_segments =
        req.uri
        |> Url.from_str
        |> Url.path
        |> Str.split_on "/"
        |> List.drop_first 1

    when (req.method, url_segments) is
        (GET, ["main.js"]) -> main_js_file |> respond_static
        (GET, ["main.css"]) -> main_css_file |> respond_static
        (GET, [""]) -> Views.Login.page! req |> respond_html
        (GET, ["login"]) -> Views.Login.page! req |> respond_html
        (GET, ["dashboard"]) -> Views.Dashboard.page! req |> respond_html
        (GET, ["todo"]) -> todo! req
        _ -> not_found! req

respond_html : Html.Node -> Result Response [ServerErr Str]_
respond_html = |html|
    Ok {
        status: 200,
        headers: [
            { name: "Content-Type", value: "text/html; charset=utf-8" },
        ],
        body: Str.to_utf8 (Html.render html),
    }

respond_static : List U8 -> Result Response [ServerErr Str]_
respond_static = |bytes|
    Ok {
        status: 200,
        headers: [
            { name: "Cache-Control", value: "max-age=120" },
        ],
        body: bytes,
    }

todo! : Request => Result Response [Server Str]_
todo! = |_req|
    page = Html.html [] [
        body [] [h1 [] [text "Todo"]],
    ]

    html = Html.render(page)

    Ok {
        status: 200,
        headers: [],
        body: Str.to_utf8 html,
    }

not_found! : Request => Result Response [ServerErr Str]_
not_found! = |req|
    page = Html.html [] [
        body [] [h1 [] [text "Not found: ${req.uri}"]],
    ]

    html = Html.render(page)

    Ok {
        status: 404,
        headers: [],
        body: Str.to_utf8 html,
    }

log_request! : Request => Result {} _
log_request! = |req|
    datetime = Utc.to_iso_8601 (Utc.now! {})
    Stdout.line! "${datetime} ${Inspect.to_str req.method} ${req.uri}"

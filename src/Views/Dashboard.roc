module [page!]

import hasnep.Html exposing [meta, title, html, div, main, button, h1, h2, script, link, body, header, text, a]
import hasnep.Attribute exposing [attribute, style, id, charset, class, src, rel, href, name, content]
import ws.Http exposing [Request]

page! : Request => Html.Node
page! = |_req|
    html [] [
        header [] [
            meta [charset "utf-8"],
            meta [name "viewport", content "width=device-width, initial-scale=2"],
            title [] [text "htmx-roc"],
            script [src "https://unpkg.com/htmx.org@2.0.4"] [],
            script [src "/main.js"] [],
            link [rel "stylesheet", href "https://unpkg.com/missing.css@1.1.3"],
            link [rel "stylesheet", href "/main.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@webtui/css/dist/full.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/gh/mshaugh/nerdfont-webfonts@latest/build/jetbrainsmono-nfm.css"],
        ],
        body [] [
            div [class "fullscreen bg"] [
                div [class "topbar"] [
                ],
                div [class "editor"] [
                ],
                div [class "bottombar"] [
                ],
            ],
        ],
    ]

module [dashboard!]

import platform.Http exposing [Request]
import template.Html exposing [meta, form, label, title, html, div, main, script, link, body, header, text, input]
import template.Attribute exposing [attribute, hidden, type, id, charset, class, src, rel, href, name, content]

dashboard! : Request => Html.Node
dashboard! = |_req|
    html [(attribute "data-webtui-theme") "dark"] [
        header [] [
            meta [charset "utf-8"],
            meta [name "viewport", content "width=device-width, initial-scale=2"],
            title [] [text "htmx-roc"],
            script [src "https://unpkg.com/htmx.org@2.0.4"] [],
            script [src "/main.js"] [],
            link [rel "stylesheet", href "/main.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@webtui/css/dist/full.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/gh/mshaugh/nerdfont-webfonts@latest/build/jetbrainsmono-nfm.css"],
        ],
        body [] [
            main [class "screen"] [
                div [class "topbar"] [
                ],
                div [id "buffer", class "buffer"] [
                ],
                div [class "bottombar"] [
                    div [class "feedback"] [
                    ],
                    div [class "status-line"] [
                    ],
                    form
                        [
                            class "command-line",
                            (attribute "hx-post") "/cli",
                            (attribute "hx-target") "#buffer",
                            (attribute "hx-swap") "innerHTML",
                        ]
                        [
                            label [class "label"] [text ":"],
                            input [class "input", type "search", name "command"],
                            input [type "submit", hidden "hidden", (attribute "hx-trigger") "key[Enter] from:body"],
                        ],
                ],
            ],
        ],
    ]

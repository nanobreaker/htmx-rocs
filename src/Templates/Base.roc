module [base]

import template.Html exposing [
    b,
    p,
    br,
    meta,
    pre,
    body,
    code,
    head,
    span,
    title,
    html,
    div,
    form,
    button,
    h1,
    h2,
    script,
    link,
    header,
    text,
    a,
]
import template.Attribute exposing [
    attribute,
    charset,
    name,
    src,
    content,
    href,
    rel,
]

base : Html.Node -> Html.Node
base = |main|
    html [(attribute "data-webtui-theme") "dark"] [
        head [] [
            meta [charset "utf-8"],
            meta [name "viewport", content "width=device-width, initial-scale=2"],
            title [] [text "htmx-roc"],
            script [src "https://unpkg.com/htmx.org@2.0.4"] [],
            script [src "/main.js"] [],
            link [rel "stylesheet", href "/main.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@webtui/css/dist/full.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/gh/mshaugh/nerdfont-webfonts@latest/build/jetbrainsmono-nfm.css"],
            link [rel "stylesheet", href "https://fonts.cdnfonts.com/css/heavy-data"],
        ],
        body [] [main],
    ]

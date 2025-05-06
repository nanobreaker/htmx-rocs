module [page]

import hasnep.Html exposing [b, p, br, meta, pre, code, head, span, title, html, div, main, form, button, h1, h2, script, link, body, header, text, a]
import hasnep.Attribute exposing [attribute, method, action, style, id, charset, class, src, rel, href, name, content]
import ws.Http exposing [Request]

import Models.Todo exposing [Todo]

page : Todo -> Html.Node
page = |todo|
    div [] []

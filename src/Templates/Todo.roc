module [template]

import platform.Http exposing [Request]
import template.Html exposing [b, p, br, meta, pre, code, head, span, title, html, div, main, form, button, h1, h2, script, link, body, header, text, a]
import template.Attribute exposing [attribute, method, action, style, id, charset, class, src, rel, href, name, content]

import Models.Todo exposing [Todo]

template : Todo -> Html.Node
template = |todo|
    div [] []

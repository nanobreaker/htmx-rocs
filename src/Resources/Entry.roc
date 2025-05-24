module [handle]

import platform.Http
import template.Html

import Templates.Entry

handle : Http.Request, List Str -> Result Http.Response [ServerErr Str]_
handle = |req, url|
    when (req, url) is
        (_, _) ->
            html =
                Templates.Entry.entry req
                |> Html.render
                |> Str.to_utf8

            Ok {
                status: 200,
                headers: [],
                body: html,
            }


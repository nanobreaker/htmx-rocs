module [register]

import platform.Http
import template.Html

register : Http.Request -> Html.Node
register = |_req|
    Html.html [] []

module [handle!]

import platform.Http

handle! : Http.Request, List Str => Result Http.Response [ServerErr Str]_
handle! = |req, url|
    when (req, url) is
        (_, _) ->
            Ok {
                status: 200,
                headers: [],
                body: Str.to_utf8 "test",
            }


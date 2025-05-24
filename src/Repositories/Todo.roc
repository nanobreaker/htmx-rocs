module [save!, find!]

import platform.Sqlite

import Models.Todo exposing [Todo]

save! : Todo, Str, Str => Result Todo _
save! = |todo, db_path, user_id|
    description =
        when todo.description is
            Some v -> v
            None -> "NULL"
    start =
        when todo.start is
            Some v -> v
            None -> "NULL"
    end =
        when todo.end is
            Some v -> v
            None -> "NULL"

    Sqlite.query!(
        {
            path: db_path,
            query:
            """
                INSERT INTO todos (user_id, title, description, start, end)
                VALUES (${user_id}, '${todo.title}', '${description}', '${start}', '${end}') 
            """,
            bindings: [],
            row: Sqlite.u64("count"),
        },
    )
    |> Result.map_ok |_| todo

find! : Str, Str, Str => Result (List Str) _
find! = |title, db_path, user_id|
    Sqlite.query_many!(
        {
            path: db_path,
            query:
            """
                SELECT * FROM todos
                WHERE todos.user_id = ${user_id}
                AND todos.title LIKE \'%${title}%\'
            """,
            bindings: [],
            rows: { Sqlite.decode_record <-
                title: Sqlite.str("title"),
                description: Sqlite.str("description"),
                start: Sqlite.str("start"),
                end: Sqlite.str("end"),
            },
        },
    )
    |> Result.map_ok |rows|
        List.map rows |row| row.title

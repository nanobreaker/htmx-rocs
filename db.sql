-- USERS
CREATE TABLE IF NOT EXISTS USERS (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    password TEXT NOT NULL
);

INSERT INTO USERS (name, password) VALUES ('root', 'root');

-- TODOS
CREATE TABLE IF NOT EXISTS TODOS (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT,
    description TEXT,
    start TEXT,
    end TEXT,

    CONSTRAINT FK_USER_ID
        FOREIGN KEY (user_id)
        REFERENCES USERS (user_id)
        ON DELETE CASCADE
);

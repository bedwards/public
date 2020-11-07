# Postgres triggers

[triggers.sql](triggers.sql)

Start postgres server

```
docker run --rm --name postgres -e POSTGRES_PASSWORD=p -v $(pwd):/host postgres
```

In a separate terminal, start postgres client

```
docker exec -it postgres psql -U postgres -q
```

At the `postgres=#` prompt

```
\include host/hello.sql
```

Expected output

```
psql:host/hello.sql:10: INFO:  Hello world
psql:host/hello.sql:30: INFO:  Hello world
  key  | bar_count
-------+-----------
 foo-1 |         1
```

References

* [meta-commands](https://www.postgresql.org/docs/current/app-psql.html)
* [create function](https://www.postgresql.org/docs/current/sql-createfunction.html)
* [PL/pgSQL structure][https://www.postgresql.org/docs/current/plpgsql-structure.html]
* [RAISE NOTICE](https://www.postgresql.org/docs/current/plpgsql-errors-and-messages.html)
* [special variables](https://www.postgresql.org/docs/current/plpgsql-trigger.html)

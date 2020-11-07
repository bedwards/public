SET client_min_messages TO WARNING;

CREATE OR REPLACE FUNCTION hello(object varchar(255)) RETURNS void AS $$
BEGIN
    RAISE INFO 'Hello %', object;
END;
$$ LANGUAGE plpgsql;

\out /dev/null
select hello('world');
\out /dev/stdout

CREATE TABLE IF NOT EXISTS foo (
    key varchar(255) primary key,
    bar_count integer
);

CREATE OR REPLACE FUNCTION hello_tg_func() RETURNS trigger AS $$
BEGIN
    RAISE INFO 'Hello %', TG_ARGV[0];
    RETURN null;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS hello_tg ON foo;

CREATE TRIGGER hello_tg
    AFTER INSERT ON foo
    EXECUTE FUNCTION hello_tg_func('world');

INSERT INTO foo VALUES ('foo-1', 0);

CREATE TABLE IF NOT EXISTS bar (
    key varchar(255) primary key,
    foo_key varchar(255) references foo(key)
);

CREATE OR REPLACE FUNCTION update_bar_count() RETURNS trigger AS $$
BEGIN
    UPDATE foo SET bar_count = bar_count + 1 WHERE key = NEW.foo_key;
    RETURN null;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_bar_count_tg ON bar;

CREATE TRIGGER update_bar_count_tg
    AFTER INSERT ON bar
    FOR EACH ROW
    EXECUTE FUNCTION update_bar_count();

INSERT INTO bar VALUES ('bar-1', 'foo-1');
SELECT * FROM foo;

DELETE FROM bar WHERE key = 'bar-1';
DELETE FROM foo WHERE key = 'foo-1';

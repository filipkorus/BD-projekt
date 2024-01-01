CREATE OR REPLACE FUNCTION stworz_klienta(
    _login VARCHAR,
    _haslo VARCHAR,
    _imie VARCHAR,
    _nazwisko VARCHAR,
    _email VARCHAR,
    _nr_tel VARCHAR,
    _nr_tel_publiczny BOOLEAN DEFAULT FALSE
)
    RETURNS VOID AS
$$
DECLARE
    user_id     INT;
    policy_name VARCHAR;
BEGIN
    BEGIN
        -- dodaj wpis w tabeli uzytkownicy
        INSERT INTO uzytkownicy (imie, nazwisko, login, email, nr_tel, nr_tel_publiczny, typ_uzytkownika)
        VALUES (_imie, _nazwisko, _login, _email, _nr_tel, _nr_tel_publiczny, 'klient');

        -- stworz uzytkownika psql
        EXECUTE 'CREATE USER ' || quote_ident(_login) || ' WITH PASSWORD ' || quote_literal(_haslo);

        -- zapisywanie id uzytkownika do zmiennej
        SELECT uid INTO user_id FROM uzytkownicy WHERE login = _login LIMIT 1 FOR UPDATE;

        -- dodaj nowego klienta do grupy uprawnien klient_group
        EXECUTE 'GRANT klient_group TO ' || quote_ident(_login);

        -- generowanie unikalnej nazwy policy
--     policy_name := 'uzytkownicy_policy_' || _login || '_' || to_char(NOW(), 'YYYYMMDDHH24MISS');

        -- row-level security policy bazujaca na user ID
--     EXECUTE 'CREATE POLICY ' || quote_ident(policy_name) || ' ON uzytkownicy USING (uid = ' || user_id || ')';

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

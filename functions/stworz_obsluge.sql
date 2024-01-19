CREATE OR REPLACE FUNCTION stworz_obsluge(
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
BEGIN
    BEGIN
        -- dodaj wpis w tabeli uzytkownicy
        INSERT INTO uzytkownicy (imie, nazwisko, login, email, nr_tel, nr_tel_publiczny, typ_uzytkownika)
        VALUES (_imie, _nazwisko, _login, _email, _nr_tel, _nr_tel_publiczny, 'obsluga_klienta');

        -- stworz uzytkownika psql
        EXECUTE 'CREATE USER ' || quote_ident(_login) || ' WITH PASSWORD ' || quote_literal(_haslo) || ' CREATEROLE';

        -- dodaj nowego pracownika obslugi klienta do grupy uprawnien obsluga_group
        EXECUTE 'GRANT obsluga_group TO ' || quote_ident(_login);

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

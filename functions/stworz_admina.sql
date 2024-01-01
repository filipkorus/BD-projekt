CREATE OR REPLACE FUNCTION stworz_admina(
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
        VALUES (_imie, _nazwisko, _login, _email, _nr_tel, _nr_tel_publiczny, 'admin');

        -- stworz uzytkownika psql
        -- flaga CREATEROLE jest po to aby admin mogl tworzyc nowych uzytkownikow psql
        EXECUTE 'CREATE USER ' || quote_ident(_login) || ' WITH PASSWORD ' || quote_literal(_haslo) || ' CREATEROLE';

        -- dodaj nowego administratora do grupy uprawnien admin_group
        -- opcja WITH ADMIN OPTION powoduje ze admini mogą dodawac innych adminow
        EXECUTE 'GRANT admin_group TO ' || quote_ident(_login) || ' WITH ADMIN OPTION';

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION usun_uzytkownika(
    _login_do_usuniecia VARCHAR
)
    RETURNS VOID AS
$$
DECLARE
    currently_logged_user_login VARCHAR;
    currently_logged_user_typ   VARCHAR;
BEGIN
    BEGIN
        SELECT current_user INTO currently_logged_user_login;

        SELECT typ_uzytkownika
        INTO currently_logged_user_typ
        FROM uzytkownicy
        WHERE login = currently_logged_user_login
        LIMIT 1 FOR UPDATE;

        IF czy_uzytkownik_z_loginem_istnieje(currently_logged_user_login) THEN
            IF currently_logged_user_typ = 'admin' THEN
                IF czy_uzytkownik_z_loginem_istnieje(_login_do_usuniecia) THEN
                    -- usun wpis z tabeli uzytkownicy
                    DELETE FROM uzytkownicy WHERE login = _login_do_usuniecia;

                    -- usun uzytkownika psql
                    EXECUTE 'DROP USER ' || quote_ident(_login_do_usuniecia);
                ELSE
                    RAISE EXCEPTION 'Uzytkownik z loginem % nie istnieje', _login_do_usuniecia;
                END IF;
            ELSE
                RAISE EXCEPTION 'Nie masz prawa do wykonania tej akcji';
            END IF;
        ELSE
            RAISE EXCEPTION 'Nie masz prawa do wykonania tej akcji';
        END IF;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

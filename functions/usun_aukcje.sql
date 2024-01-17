CREATE OR REPLACE FUNCTION usun_aukcje(
    aukcja_id INT
)
    RETURNS VOID AS
$$
DECLARE
    currently_logged_user_login VARCHAR;
    currently_logged_user_typ   VARCHAR;
    currently_logged_user_id INT;
BEGIN
    BEGIN
        SELECT current_user INTO currently_logged_user_login;

        SELECT typ_uzytkownika, uid
        INTO currently_logged_user_typ, currently_logged_user_id
        FROM uzytkownicy
        WHERE login = currently_logged_user_login
        LIMIT 1;

        -- admin i obsluga moga usunac kazda aukcje
        IF currently_logged_user_typ = 'admin' OR currently_logged_user_typ = 'obsluga_klienta' THEN
            -- Sprawdzenie czy aukcja istnieje
            IF NOT EXISTS (SELECT 1 FROM aukcje WHERE aid = aukcja_id) THEN
                RAISE EXCEPTION 'Aukcja (ID=%) nie istnieje', aukcja_id;
            ELSE
                -- usun aukcje
                DELETE FROM aukcje WHERE aid = aukcja_id;
            END IF;

        -- klient i dealer moga usunac tylko swoja aukcje
        ELSEIF currently_logged_user_typ = 'klient' OR currently_logged_user_typ = 'dealer' THEN
            IF NOT EXISTS (SELECT 1 FROM aukcje  WHERE aid = aukcja_id AND wystawione_przez_uid = currently_logged_user_id) THEN
                RAISE EXCEPTION 'Aukcja (ID=%) nie istnieje', aukcja_id;
            ELSEIF NOT EXISTS (SELECT 1 FROM aukcje  WHERE aid = aukcja_id AND sprzedane = FALSE) THEN
                RAISE EXCEPTION 'Nie mozna usunac aukcji zakonczonej sprzedaza';
            ELSE
                -- usun aukcje
                DELETE FROM aukcje WHERE aid = aukcja_id AND wystawione_przez_uid = currently_logged_user_id AND sprzedane = FALSE;
            END IF;
        END IF;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

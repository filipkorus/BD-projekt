-- uzytkownik ma miec mozliwosc wyswietlania swoich aktualnych aukcji

CREATE OR REPLACE FUNCTION wyswietl_aktualne_aukcje()
    RETURNS TABLE
            (
                tytul              VARCHAR(255),
                "data wystawienia" TEXT,
                "koniec aukcji"    TEXT,
                cena               INT4,
                sprzedane          BOOLEAN,
                czy_zatwierdzona   BOOLEAN
            )
AS
$$
DECLARE
    currently_logged_user_login VARCHAR;
    currently_logged_user_id VARCHAR;
BEGIN
    SELECT current_user INTO currently_logged_user_login;

    SELECT uid INTO currently_logged_user_id FROM uzytkownicy WHERE login = currently_logged_user_login LIMIT 1 FOR UPDATE;

    IF czy_uzytkownik_z_id_istnieje(currently_logged_user_id) THEN
        RETURN QUERY SELECT a.tytul,
                            to_char(a.data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
                            to_char(a.koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
                            a.cena,
                            a.sprzedane,
                            a.czy_zatwierdzona
                     from aukcje AS a
                     where (a.sprzedane = FALSE and a.koniec_aukcji > now() AND czy_zatwierdzona = TRUE)
                       and a.wystawione_przez_uid = currently_logged_user_id;
    ELSE
        RAISE EXCEPTION 'Uzytkownik z ID % nie istnieje', currently_logged_user_id;
    END IF;
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred: %', SQLERRM;

END;
$$ LANGUAGE plpgsql;

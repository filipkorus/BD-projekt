-- uzytkownik ma miec mozliwosc wyswietlania swoich aktualnych aukcji

CREATE OR REPLACE FUNCTION wyswietl_aktualne_aukcje_uzytkownika(
    id_uzytkownika INT
)
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
BEGIN
    IF czy_uzytkownik_z_id_istnieje(id_uzytkownika) THEN
        RETURN QUERY SELECT a.tytul,
                            to_char(a.data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
                            to_char(a.koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
                            a.cena,
                            a.sprzedane,
                            a.czy_zatwierdzona
                     from aukcje AS a
                     where (a.sprzedane = FALSE and a.koniec_aukcji > now() AND czy_zatwierdzona = TRUE)
                       and a.wystawione_przez_uid = id_uzytkownika;
    ELSE
        RAISE EXCEPTION 'Uzytkownik z ID % nie istnieje', id_uzytkownika;
    END IF;
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred: %', SQLERRM;

END;
$$ LANGUAGE plpgsql;

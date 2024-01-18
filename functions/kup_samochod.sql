CREATE OR REPLACE FUNCTION kup_samochod(
    aukcja_id INT
)
    RETURNS VOID AS
$$
DECLARE
    currently_logged_user_typ   VARCHAR;
    kupujacy_uid INT;
BEGIN
    BEGIN
        SELECT typ_uzytkownika INTO currently_logged_user_typ FROM uzytkownicy WHERE login = current_user;

        IF currently_logged_user_typ = 'admin' OR currently_logged_user_typ = 'obsluga_klienta' THEN
            RAISE EXCEPTION 'Nie mozesz kupic samochodu';
        END IF;

        -- Sprawdzenie czy aukcja istnieje i nie jest zakończona
        IF EXISTS (SELECT 1
                   FROM aukcje
                   WHERE aid = aukcja_id
                     AND (koniec_aukcji < NOW() OR sprzedane = TRUE OR czy_zatwierdzona = FALSE) FOR UPDATE) THEN
            RAISE EXCEPTION 'Aukcja (ID=%) nie istnieje lub jest juz zakonczona', aukcja_id;
        ELSE
            SELECT uid INTO kupujacy_uid FROM uzytkownicy WHERE login = current_user LIMIT 1;
            -- Sprawdzenie czy kupujący jest różny od wystawiającego aukcję
            IF EXISTS (SELECT 1
                       FROM aukcje
                       WHERE aid = aukcja_id
                         AND wystawione_przez_uid <> kupujacy_uid FOR UPDATE)
            THEN
                -- Aktualizacja danych aukcji - oznaczenie jako sprzedane i przypisanie kupującego
                UPDATE aukcje
                SET sprzedane         = TRUE,
                    kupione_przez_uid = kupujacy_uid
                WHERE aid = aukcja_id;
            ELSE
                RAISE EXCEPTION 'Nie możesz kupic wlasnej aukcji';
            END IF;
        END IF;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION kup_samochod(
    aukcja_id INT,
    login_kupujacego VARCHAR(30)
)
    RETURNS VOID AS
$$
DECLARE
    kupujacy_uid INT;
BEGIN
    BEGIN
        -- Sprawdzenie czy aukcja istnieje i nie jest zakończona
        IF EXISTS (SELECT 1
                   FROM aukcje
                   WHERE aid = aukcja_id
                     AND (koniec_aukcji < NOW() OR sprzedane = TRUE)
                       FOR UPDATE) THEN
            RAISE EXCEPTION 'Aukcja (ID=%) nie istnieje lub jest już zakończona', aukcja_id;
        ELSE
            SELECT uid INTO kupujacy_uid FROM uzytkownicy WHERE login = login_kupujacego LIMIT 1 FOR UPDATE;
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
                RAISE EXCEPTION 'Nie możesz kupić własnej aukcji';
            END IF;
        END IF;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

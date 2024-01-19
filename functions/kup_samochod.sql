CREATE OR REPLACE FUNCTION kup_samochod(
    aukcja_id INT
)
    RETURNS VOID AS
$$
BEGIN
    BEGIN
        IF EXISTS (SELECT 1
                   FROM uzytkownicy
                   WHERE login = current_user
                     AND (typ_uzytkownika = 'admin' OR
                          typ_uzytkownika = 'obsluga_klienta')) THEN
            RAISE EXCEPTION 'Nie mozesz kupic samochodu';
        END IF;

        -- Sprawdzenie czy aukcja istnieje i nie jest zakończona
        IF NOT EXISTS (SELECT 1 FROM otwarte_aukcje WHERE "ID aukcji" = aukcja_id) THEN
            RAISE EXCEPTION 'Aukcja (ID=%) nie istnieje lub jest juz zakonczona', aukcja_id;
        ELSE
            -- Sprawdzenie czy kupujący jest różny od wystawiającego aukcję
            IF EXISTS (SELECT 1 FROM otwarte_aukcje WHERE "ID aukcji" = aukcja_id AND "wystawione przez" <> current_user)
            THEN
                -- Aktualizacja danych aukcji - oznaczenie jako sprzedane i przypisanie kupującego
                UPDATE aukcje
                SET sprzedane         = TRUE,
                    kupione_przez_uid = (SELECT uid FROM uzytkownicy WHERE login = current_user LIMIT 1)
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

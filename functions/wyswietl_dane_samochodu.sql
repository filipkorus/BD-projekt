CREATE OR REPLACE FUNCTION wyswietl_dane_samochodu(
    aukcja_id INT
)
    RETURNS TABLE
            (
                marka          VARCHAR(255),
                model          VARCHAR(255),
                rok_produkcji  INT2,
                przebieg       INT4,
                "typ nadwozia" VARCHAR(255),
                "typ paliwa"   VARCHAR(255),
                pojemnosc_baku INT2,
                nowy           BOOLEAN,
                powypadkowy    BOOLEAN,
                moc_silnika    INT2,
                spalanie       INT2,
                opis           TEXT
            )
AS
$$
BEGIN
    -- sprawdzanie czy aukcja istnieje
    IF NOT EXISTS (SELECT 1 FROM aukcje WHERE aid = aukcja_id AND koniec_aukcji > NOW() AND sprzedane = FALSE) THEN
        RAISE EXCEPTION 'Auction with ID % does not exist', aukcja_id;
    END IF;

    RETURN QUERY SELECT s.marka,
                        s.model,
                        s.rok_produkcji,
                        s.przebieg,
                        tn.nazwa AS "typ nadwozia",
                        tp.nazwa AS "typ paliwa",
                        s.pojemnosc_baku,
                        s.nowy,
                        s.powypadkowy,
                        s.moc_silnika,
                        s.spalanie,
                        s.opis
                 FROM samochody s
                          INNER JOIN aukcje a ON s.sid = a.sid
                          LEFT JOIN typ_nadwozia tn ON s.nid = tn.nid
                          LEFT JOIN typ_paliwa tp ON s.pid = tp.pid
                 WHERE a.aid = aukcja_id;

    -- nie znaleziono auta
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Car details for Auction ID % not found', aukcja_id;
    END IF;
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred: %', SQLERRM;

END;
$$ LANGUAGE plpgsql;

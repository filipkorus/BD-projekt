CREATE OR REPLACE FUNCTION blokuj_usuwanie_aukcji_i_samochodow_po_sprzedazy()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'aukcje' THEN
        IF OLD.sprzedane = TRUE AND OLD.kupione_przez_uid IS NOT NULL THEN
            RAISE EXCEPTION 'Nie mozna usuwac aukcji po zakonczeniu sprzedazy.';
        END IF;
    END IF;

    IF TG_TABLE_NAME = 'samochody' THEN
        -- Znajdź aukcje powiazana z tym samochodem
        IF EXISTS (SELECT 1 FROM aukcje WHERE sid = OLD.sid AND sprzedane=TRUE) THEN
            RAISE EXCEPTION 'Nie mozna usuwac informacji o samochodzie powiazanej z zakonczona aukcja.';
        END IF;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER blokuj_usuwanie_aukcji_po_sprzedazy_trigger
    BEFORE DELETE ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION blokuj_usuwanie_aukcji_i_samochodow_po_sprzedazy();

CREATE OR REPLACE TRIGGER blokuj_usuwanie_samochodow_po_sprzedazy_trigger
    BEFORE DELETE ON samochody
    FOR EACH ROW
EXECUTE FUNCTION blokuj_usuwanie_aukcji_i_samochodow_po_sprzedazy();

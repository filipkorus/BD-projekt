CREATE OR REPLACE FUNCTION blokuj_zmiane_daty_wystawienia()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Nowa aukcja, sprawdź datę wystawienia
        IF NEW.data_wystawienia != NOW() THEN
            RAISE EXCEPTION 'Nie można zmieniać daty wystawienia aukcji.';
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        -- Aktualizacja aukcji, sprawdź czy zmieniono datę wystawienia
        IF NEW.data_wystawienia != OLD.data_wystawienia THEN
            RAISE EXCEPTION 'Nie mozna zmieniac daty wystawienia aukcji';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER blokuj_zmiane_daty_wystawienia_trigger
    BEFORE INSERT OR UPDATE ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION blokuj_zmiane_daty_wystawienia();

CREATE OR REPLACE FUNCTION ustaw_zatwierdzenie_dealera()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.czy_zatwierdzona := FALSE;

    IF NEW.wystawione_przez_uid IN (SELECT uid FROM uzytkownicy WHERE typ_uzytkownika = 'dealer') THEN
        NEW.czy_zatwierdzona := TRUE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ustaw_zatwierdzenie_dealera_trigger
    BEFORE INSERT
    ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION ustaw_zatwierdzenie_dealera();

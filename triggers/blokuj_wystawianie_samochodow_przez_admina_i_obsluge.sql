CREATE OR REPLACE FUNCTION blokuj_wystawianie_samochodow_przez_admina_i_obsluge()
    RETURNS TRIGGER AS $$
DECLARE
    currently_logged_user_typ   VARCHAR;
    currently_logged_user_id INT;
BEGIN
    SELECT typ_uzytkownika, uid
    INTO currently_logged_user_typ, currently_logged_user_id
    FROM uzytkownicy
    WHERE login = current_user
    LIMIT 1;

    IF NEW.wystawione_przez_uid = currently_logged_user_id AND (currently_logged_user_typ = 'admin' OR currently_logged_user_typ = 'obsluga_klienta') THEN
        RAISE EXCEPTION 'Nie mozesz wystawic samochodu na sprzedaz jako administrator lub obsluga';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER blokuj_wystawianie_samochodow_przez_admina_i_obsluge_trigger
    BEFORE INSERT OR UPDATE ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION blokuj_wystawianie_samochodow_przez_admina_i_obsluge();

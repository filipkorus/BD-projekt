CREATE OR REPLACE FUNCTION blokuj_usuwanie_nieswoich_aukcji_i_samochodow()
    RETURNS TRIGGER AS
$$
DECLARE
    currently_logged_user_typ   VARCHAR;
    currently_logged_user_id INT;
BEGIN
    SELECT typ_uzytkownika, uid
    INTO currently_logged_user_typ, currently_logged_user_id
    FROM uzytkownicy
    WHERE login = current_user
    LIMIT 1;

    IF TG_TABLE_NAME = 'aukcje' THEN
        -- nie mozna usunac nieswojej aukcji (wyjatek to admin i obsluga)
        IF OLD.wystawione_przez_uid != currently_logged_user_id AND currently_logged_user_typ != 'admin' AND currently_logged_user_typ != 'obsluga_klienta' THEN
            RAISE EXCEPTION 'Nie mozna usunac nieswojej aukcji';
        END IF;
    END IF;

    IF TG_TABLE_NAME = 'samochody' THEN
        -- nie mozna usunac nieswojego samochodu (wyjatek to admin i obsluga)
        IF NOT EXISTS (SELECT 1 FROM aukcje WHERE sid = OLD.sid AND wystawione_przez_uid=currently_logged_user_id) AND currently_logged_user_typ != 'admin' AND currently_logged_user_typ != 'obsluga_klienta' THEN
            RAISE EXCEPTION 'Nie mozna usunac nieswojego samochodu';
        END IF;
    END IF;

    RETURN OLD;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER blokuj_usuwanie_nieswoich_aukcji_trigger
    BEFORE DELETE
    ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION blokuj_usuwanie_nieswoich_aukcji_i_samochodow();

CREATE OR REPLACE TRIGGER blokuj_usuwanie_nieswoich_samochodow_trigger
    BEFORE DELETE
    ON samochody
    FOR EACH ROW
EXECUTE FUNCTION blokuj_usuwanie_nieswoich_aukcji_i_samochodow();

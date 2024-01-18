CREATE OR REPLACE FUNCTION zablokuj_usuwanie_aukcji()
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

    -- nie mozna usunac nieswojej aukcji (wyjatek to admin i obsluga) oraz nie mozna usunac aukcji zakonczonej sprzedaza
    IF (OLD.wystawione_przez_uid != currently_logged_user_id AND currently_logged_user_typ != 'admin' AND currently_logged_user_typ != 'obsluga_klienta') OR OLD.sprzedane=TRUE THEN
        RAISE EXCEPTION 'Nie mozna usunac aukcji';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER zablokuj_usuwanie_aukcji_trigger
    AFTER DELETE
    ON aukcje
    FOR EACH ROW
EXECUTE FUNCTION zablokuj_usuwanie_aukcji();

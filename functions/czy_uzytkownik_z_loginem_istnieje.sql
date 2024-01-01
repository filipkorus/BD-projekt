CREATE OR REPLACE FUNCTION czy_uzytkownik_z_loginem_istnieje(
    login_uzytkownika VARCHAR(30)
)
    RETURNS BOOLEAN AS
$$
DECLARE
    czy_istnieje BOOLEAN;
BEGIN
    BEGIN
        SELECT TRUE INTO czy_istnieje
        FROM uzytkownicy
        WHERE login = login_uzytkownika;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            czy_istnieje := FALSE;
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;

    RETURN czy_istnieje;
END;
$$ LANGUAGE plpgsql;

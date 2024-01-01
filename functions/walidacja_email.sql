CREATE OR REPLACE FUNCTION walidacja_email(email VARCHAR(255)) RETURNS BOOLEAN AS
$$
BEGIN
    IF email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$' THEN
        RETURN TRUE;
    END IF;

    RAISE NOTICE 'Nieprawidlowy format adresu e-mail: %', email;
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

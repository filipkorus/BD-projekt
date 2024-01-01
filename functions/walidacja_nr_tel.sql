CREATE OR REPLACE FUNCTION walidacja_nr_tel(nr_tel VARCHAR(9)) RETURNS BOOLEAN AS
$$
BEGIN
    IF nr_tel ~ '^[0-9]{9}$' THEN
        RETURN TRUE;
    END IF;

    RAISE NOTICE 'Nieprawidlowy format numeru telefonu: %', nr_tel;
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

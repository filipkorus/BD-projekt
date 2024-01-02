CREATE OR REPLACE FUNCTION wystaw_samochod(
    _marka VARCHAR(255),
    _model VARCHAR(255),
    _rok_produkcji INT,
    _przebieg INT4,
    _kolor_karoserii VARCHAR(255),
    _id_typu_paliwa INT,
    _pojemnosc_baku INT,
    _id_typu_nadwozia INT,
    _nowy BOOLEAN,
    _moc_silnika INT,
    _spalanie INT,
    _opis TEXT,
    _tytul VARCHAR(255),
    _cena INT,
    _login_wystawiajacego VARCHAR(30),
    _data_zakonczenia timestamptz,
    _powypadkowy BOOLEAN DEFAULT NULL
)
    RETURNS VOID AS
$$
DECLARE
    samochod_id INT;
    uid_wystawiajacego INT;
BEGIN
    BEGIN
        SELECT uid INTO uid_wystawiajacego FROM uzytkownicy WHERE login = _login_wystawiajacego FOR UPDATE;

        IF uid_wystawiajacego IS NULL THEN
            RAISE EXCEPTION 'Uzytkownik z loginem % nie istnieje', _login_wystawiajacego;
        END IF;

        -- dodawanie wpisu do tabeli samochody
        INSERT INTO samochody (marka, model, rok_produkcji, przebieg, kolor_karoserii, pid, pojemnosc_baku, nid, nowy,
                               powypadkowy, moc_silnika, spalanie, opis)
        VALUES (_marka, _model, _rok_produkcji, _przebieg, _kolor_karoserii, _id_typu_paliwa, _pojemnosc_baku,
                _id_typu_nadwozia, _nowy,
                _powypadkowy, _moc_silnika, _spalanie, _opis)
        RETURNING sid INTO samochod_id;

        -- tworzenie wpisu w tabeli aukcje
        INSERT INTO aukcje (tytul, wystawione_przez_uid, cena, sid, koniec_aukcji)
        VALUES (_tytul, uid_wystawiajacego, _cena, samochod_id, _data_zakonczenia);

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;
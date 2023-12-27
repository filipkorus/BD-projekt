drop table aukcje;
drop table samochody;
drop table uzytkownicy;
drop table typ_nadwozia;
drop table typ_paliwa;

CREATE OR REPLACE FUNCTION walidacjaEmail(email VARCHAR(255)) RETURNS BOOLEAN AS
$$
BEGIN
    IF email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,4}$' THEN
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Nieprawidlowy format adresu e-mail: %', email;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION walidacjaNrTel(nr_tel VARCHAR(9)) RETURNS BOOLEAN AS
$$
BEGIN
    IF nr_tel ~ '^[0-9]{9}$' THEN
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Nieprawidlowy format numeru telefonu: %', nr_tel;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE uzytkownicy
(
    uid              SERIAL PRIMARY KEY,
    imie             VARCHAR(255)              NOT NULL,
    nazwisko         VARCHAR(255)              NOT NULL,
    login            VARCHAR(30) UNIQUE        NOT NULL,
    email            VARCHAR(255) UNIQUE       NOT NULL CHECK ( walidacjaEmail(email) ),
    nr_tel           VARCHAR(9) UNIQUE         NOT NULL CHECK ( walidacjaNrTel(nr_tel) ),
    nr_tel_publiczny BOOLEAN     DEFAULT FALSE NOT NULL, -- domyslnie nr jest prywatny
    data_dolaczenia  timestamptz DEFAULT NOW() NOT NULL,
    typ_uzytkownika  VARCHAR(50)               NOT NULL  -- TODO: trigger walidujacy wpisy: admin, obsluga_klienta, klient, dealer
);

CREATE TABLE typ_paliwa
(
    pid   SERIAL PRIMARY KEY,
    nazwa VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE typ_nadwozia
(
    nid      SERIAL PRIMARY KEY,
    nazwa    VARCHAR(255) UNIQUE     NOT NULL,
    przyklad VARCHAR(255) DEFAULT '' NOT NULL
);

CREATE TABLE samochody
(
    sid             SERIAL PRIMARY KEY,
    marka           VARCHAR(255) NOT NULL,
    model           VARCHAR(255) NOT NULL,
    rok_produkcji   INT2         NOT NULL,
    przebieg        INT4         NOT NULL,
    kolor_karoserii VARCHAR(255) NOT NULL,
    pid             INT          NOT NULL REFERENCES typ_paliwa (pid) ON UPDATE CASCADE ON DELETE RESTRICT,
    pojemnosc_baku  INT2,
    nid             INT          NOT NULL REFERENCES typ_nadwozia (nid) ON UPDATE CASCADE ON DELETE RESTRICT,
    nowy            BOOLEAN      NOT NULL,
    powypadkowy     BOOLEAN CHECK ((nowy = FALSE AND powypadkowy IS NOT NULL) OR nowy = TRUE),
    moc_silnika     INT2         NOT NULL,
    spalanie        INT2,
    opis            TEXT
);

CREATE TABLE aukcje
(
    aid                           SERIAL PRIMARY KEY,
    tytul                         VARCHAR(255)              NOT NULL,
    data_wystawienia              timestamptz DEFAULT NOW() NOT NULL,
    koniec_aukcji                 timestamptz DEFAULT (NOW() + interval '30 day'),
    wystawione_przez_uid          INT                       NOT NULL REFERENCES uzytkownicy (uid) ON UPDATE CASCADE ON DELETE CASCADE, -- usunac aukcje moze tylko jej wystawca, admin lub obsluga_klienta
    cena                          INT4                      NOT NULL,
    sid                           INT                       NOT NULL REFERENCES samochody (sid) ON UPDATE CASCADE ON DELETE RESTRICT,
    zatwierdzona_przez_pracownika BOOLEAN,                                                                                             -- jest NOT NULL tylko wtedy gdy aukcja jest wystawiona przez klienta (indywidulanego), moze byc zatwierdzone tylko przez admina lub pracownika oblugi
    sprzedane                     BOOLEAN                   NOT NULL,
    kupione_przez_uid             INT REFERENCES uzytkownicy (uid) ON UPDATE CASCADE ON DELETE RESTRICT
);

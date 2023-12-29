drop table if exists aukcje;
drop table if exists samochody;
drop table if exists uzytkownicy;
drop table if exists typ_nadwozia;
drop table if exists typ_paliwa;

drop function if exists walidacja_email(VARCHAR(255));
drop function if exists walidacja_nr_tel(VARCHAR(9));

CREATE OR REPLACE FUNCTION walidacja_email(email VARCHAR(255)) RETURNS BOOLEAN AS
$$
BEGIN
    RETURN TRUE; -- TODO: fix in production
    IF email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,4}$' THEN
        RETURN TRUE;
    ELSE
        RAISE NOTICE 'Nieprawidlowy format adresu e-mail: %', email;
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION walidacja_nr_tel(nr_tel VARCHAR(9)) RETURNS BOOLEAN AS
$$
BEGIN
    IF nr_tel ~ '^[0-9]{9}$' THEN
        RETURN TRUE;
    ELSE
        RAISE NOTICE 'Nieprawidlowy format numeru telefonu: %', nr_tel;
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION czyHasloPoprawne(_login VARCHAR(30), _haslo TEXT, hash_from_db TEXT) RETURNS BOOLEAN AS
-- $$
-- DECLARE
--     hashed_input TEXT;
-- BEGIN
--     SELECT crypt(_haslo, hash_from_db) INTO hashed_input;
--
--     RETURN EXISTS (SELECT 1
--                    FROM uzytkownicy
--                    WHERE login = _login
--                      AND haslo = hashed_input);
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE FUNCTION dodajUzytkownika(
--     _imie VARCHAR(255),
--     _nazwisko VARCHAR(255),
--     _login VARCHAR(30),
--     _haslo TEXT,
--     _email VARCHAR(255),
--     _nr_tel VARCHAR(9),
--     _nr_tel_publiczny BOOLEAN,
--     _typ_uzytkownika VARCHAR(50)
-- ) RETURNS VOID AS
-- $$
-- DECLARE
--     hashed_password TEXT;
-- BEGIN
--     hashed_password := crypt(_haslo, gen_salt('bf'));
--
--     INSERT INTO uzytkownicy (imie, nazwisko, login, haslo, email, nr_tel, nr_tel_publiczny, typ_uzytkownika)
--     VALUES (_imie, _nazwisko, _login, hashed_password, _email, _nr_tel, _nr_tel_publiczny, _typ_uzytkownika);
-- END;
-- $$ LANGUAGE plpgsql;


CREATE TABLE uzytkownicy
(
    uid              SERIAL PRIMARY KEY,
    imie             VARCHAR(255)              NOT NULL CHECK (LENGTH(imie) > 1 AND imie !~ '^[A-Z]\.$'),
    nazwisko         VARCHAR(255)              NOT NULL CHECK (LENGTH(nazwisko) > 1 AND nazwisko !~ '^[A-Z]\.$'),
    login            VARCHAR(30) UNIQUE        NOT NULL,
    haslo            TEXT                      NOT NULL,
    email            VARCHAR(255) UNIQUE       NOT NULL CHECK ( walidacja_email(email) ),
    nr_tel           VARCHAR(9) UNIQUE         NOT NULL CHECK ( walidacja_nr_tel(nr_tel) ),
    nr_tel_publiczny BOOLEAN     DEFAULT FALSE NOT NULL, -- domyslnie nr jest prywatny
    data_dolaczenia  timestamptz DEFAULT NOW() NOT NULL,
    typ_uzytkownika  VARCHAR(25)               NOT NULL CHECK ( typ_uzytkownika = 'admin' OR
                                                                typ_uzytkownika = 'obsluga_klienta' OR
                                                                typ_uzytkownika = 'klient' OR
                                                                typ_uzytkownika = 'dealer' )
);

CREATE TABLE typ_paliwa
(
    pid   SERIAL PRIMARY KEY,
    nazwa VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO typ_paliwa (nazwa)
VALUES ('Benzyna'),
       ('Benzyna+CNG'),
       ('Benzyna+LPG'),
       ('Diesel'),
       ('Elektryczny'),
       ('Etanol'),
       ('Hybryda'),
       ('Wodor');

CREATE TABLE typ_nadwozia
(
    nid      SERIAL PRIMARY KEY,
    nazwa    VARCHAR(255) UNIQUE     NOT NULL,
    przyklad VARCHAR(255) DEFAULT '' NOT NULL
);

INSERT INTO typ_nadwozia (nazwa, przyklad)
VALUES ('Auta male', 'Citroen C1, Fiat 500, Smart, Kia Picanto'),
       ('Auta miejskie', 'Opel Corsa, Ford Fiesta, Renault Clio'),
       ('Coupe', 'Audi A5, BMW 4, Ford Mustang'),
       ('Kabriolet', 'Mazda MX-5, Peugeot 207 CC, Porsche Boxster'),
       ('Kompakt', 'Volkswagen Golf, Ford Focus, Toyota Auris'),
       ('Kombi', 'Skoda Octavia Kombi, Audi A4 Avant, BMW 5 Touring'),
       ('Minivan', 'Renault Scenic, Citreon C4 Picasso, Opel Zafira'),
       ('Sedan', 'Volkswagen Passat, Opel Insignia, Mercedes Klasa C'),
       ('SUV', 'Volvo XC 60, Toyota RAV4, Kia Sportage');

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

INSERT INTO uzytkownicy (imie, nazwisko, login, haslo, email, nr_tel, nr_tel_publiczny, typ_uzytkownika)
VALUES ('Jan', 'Kowalski', 'jkowalski', 'haslo123', 'jan.kowalski@wp.pl', '123456789', TRUE, 'klient'),
       ('Anna', 'Nowak', 'anowak', 'qwerty', 'anna.nowak@example.com', '987654321', FALSE, 'dealer'),
       ('Adam', 'Majewski', 'amajewski', 'p@ssw0rd', 'adam.majewski@example.com', '555666777', TRUE, 'klient');

INSERT INTO samochody (marka, model, rok_produkcji, przebieg, kolor_karoserii, pid, pojemnosc_baku, nid, nowy,
                       powypadkowy, moc_silnika, spalanie, opis)
VALUES ('Volkswagen', 'Golf', 2019, 50000, 'Czarny', 1, 50, 5, FALSE, TRUE, 120, 6, 'Samochód w dobrym stanie.'),
       ('Ford', 'Mustang', 2022, 1000, 'Czerwony', 1, 60, 3, TRUE, FALSE, 350, 12, 'Nowy model z silnikiem V8.'),
       ('Opel', 'Corsa', 2018, 30000, 'Biały', 2, 45, 2, FALSE, TRUE, 100, 5, 'Używany, lekkie ślady użytkowania.');

INSERT INTO aukcje (tytul, data_wystawienia, koniec_aukcji, wystawione_przez_uid, cena, sid,
                    zatwierdzona_przez_pracownika, sprzedane, kupione_przez_uid)
VALUES ('VW Golf 2019', NOW(), (NOW() + interval '30 day'), 1, 25000, 1, NULL, FALSE, NULL),
       ('Nowy Ford Mustang 2022', NOW(), (NOW() + interval '45 day'), 2, 70000, 2, TRUE, FALSE, NULL),
       ('Opel Corsa 2018', NOW(), (NOW() + interval '25 day'), 3, 15000, 3, NULL, FALSE, NULL);

CREATE TABLE uzytkownicy
(
    uid              SERIAL PRIMARY KEY,
    imie             VARCHAR(255)              NOT NULL CHECK (LENGTH(imie) > 1 AND imie !~ '^[A-Z]\.$'),
    nazwisko         VARCHAR(255)              NOT NULL CHECK (LENGTH(nazwisko) > 1 AND nazwisko !~ '^[A-Z]\.$'),
    login            VARCHAR(30) UNIQUE        NOT NULL,
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
    powypadkowy     BOOLEAN CHECK ((nowy = FALSE AND powypadkowy IS NOT NULL) OR (nowy = TRUE AND powypadkowy IS NULL)),
    moc_silnika     INT2         NOT NULL,
    spalanie        INT2,
    opis            TEXT
);

CREATE TABLE aukcje
(
    aid                  SERIAL PRIMARY KEY,
    tytul                VARCHAR(255) NOT NULL,
    data_wystawienia     timestamptz           DEFAULT NOW() NOT NULL,
    koniec_aukcji        timestamptz           DEFAULT (NOW() + interval '30 day'),
    wystawione_przez_uid INT          NOT NULL REFERENCES uzytkownicy (uid) ON UPDATE CASCADE ON DELETE CASCADE, -- usunac aukcje moze tylko jej wystawca, admin lub obsluga_klienta
    cena                 INT4         NOT NULL,
    sid                  INT          NOT NULL REFERENCES samochody (sid) ON UPDATE CASCADE ON DELETE RESTRICT,
    czy_zatwierdzona     BOOLEAN      NOT NULL DEFAULT FALSE,                                                    -- gdy aukcja jest wystawiona przez klienta (indywidulanego) moze byc zatwierdzona tylko przez admina lub pracownika oblugi, aukcje dealera są automatycznie akceptowane
    sprzedane            BOOLEAN      NOT NULL CHECK ( (sprzedane = TRUE AND kupione_przez_uid IS NOT NULL) OR
                                                       (sprzedane = FALSE AND kupione_przez_uid IS NULL) ) DEFAULT FALSE,
    kupione_przez_uid    INT REFERENCES uzytkownicy (uid) ON UPDATE CASCADE ON DELETE RESTRICT CHECK ( kupione_przez_uid !=  wystawione_przez_uid )
);

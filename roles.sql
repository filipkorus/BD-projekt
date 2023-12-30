SET ROLE admin;

DROP USER IF EXISTS administrator; -- usuwamy uzytkownika

CREATE USER administrator WITH PASSWORD 'admin';

-- admin nie moze updateowac kolumn sprzedane, kupione_przez_uid w tabeli aukcje
-- nie moze tez robic insert do tabeli aukcje
GRANT SELECT, UPDATE (aid,
                      tytul,
                      data_wystawienia,
                      koniec_aukcji,
                      wystawione_przez_uid,
                      cena,
                      sid,
                      czy_zatwierdzona), DELETE ON aukcje TO administrator;

-- admin może CRUD na tabelach z paliwami oraz z nadwoziami
GRANT SELECT, UPDATE, INSERT, DELETE ON typ_paliwa, typ_nadwozia TO administrator;

-- admin nie może dodawac nowych samochodow
GRANT SELECT, UPDATE, DELETE ON samochody TO admin;

SET ROLE administrator;

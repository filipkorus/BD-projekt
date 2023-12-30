SET ROLE admin;

-- usuwamy uzytkownika
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM administrator;
DROP USER IF EXISTS administrator;

-- flaga CREATEROLE jest po to aby admin mogl tworzyc nowych uzytkownikow psql
CREATE USER administrator WITH PASSWORD 'admin' CREATEROLE;

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
GRANT SELECT, UPDATE, DELETE ON samochody TO administrator;

-- admin moze zarzadzac uzytkownikami
GRANT SELECT, INSERT, UPDATE, DELETE ON uzytkownicy TO administrator;

SET ROLE administrator;

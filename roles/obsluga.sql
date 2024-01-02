CREATE ROLE obsluga_group;

-- obsluga nie moze updateowac kolumn sprzedane, kupione_przez_uid w tabeli aukcje
-- nie moze tez robic insert do tabeli aukcje
GRANT SELECT, UPDATE (aid, tytul, data_wystawienia, koniec_aukcji, wystawione_przez_uid, cena, sid,
                      czy_zatwierdzona), DELETE ON aukcje TO obsluga_group;

-- obsluga może CRUD na tabelach z paliwami oraz z nadwoziami
GRANT SELECT, UPDATE, INSERT, DELETE ON typ_paliwa, typ_nadwozia TO obsluga_group;

-- osbluga nie może dodawac nowych samochodow
GRANT SELECT, UPDATE, DELETE ON samochody TO obsluga_group;

-- obsluga moze zarzadzac uzytkownikami
GRANT SELECT, INSERT, UPDATE, DELETE ON uzytkownicy TO obsluga_group;
GRANT USAGE, SELECT ON SEQUENCE uzytkownicy_uid_seq TO obsluga_group;

-- GRANT CREATE ON SCHEMA public TO admin_group;

-- obsluga musi miec mozliwosc tworzenia POLICY (create policy...)
-- GRANT CREATE ON SCHEMA public TO obsluga_group;

-- obsluga moze ogladac wszystkie aukcje
GRANT SELECT ON wszystkie_aukcje_uprzywilejowany_dostep TO obsluga_group;

-- obsluga musi miec ADMIN OPTION w grupie klient_group (aby mogl innym nadawac te uprawnienia)
GRANT klient_group TO obsluga_group WITH ADMIN OPTION;

-- obsluga musi miec ADMIN OPTION w grupie dealer_group (aby mogl innym nadawac te uprawnienia)
GRANT dealer_group TO obsluga_group WITH ADMIN OPTION;

-- obsluga moze dodawac nowych klientow i dealerow
GRANT ALL ON FUNCTION stworz_klienta TO obsluga_group;
GRANT ALL ON FUNCTION stworz_dealera TO obsluga_group;

-- admin nie moze kupowac i wystawiac samochodow
REVOKE ALL ON FUNCTION kup_samochod FROM obsluga_group; -- sprawdzic czy to dziala (czy admin rzeczywiscie nie moze kupic/wystawic samochodu)
REVOKE ALL ON FUNCTION wystaw_samochod FROM obsluga_group; -- to tez

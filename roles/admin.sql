CREATE ROLE admin_group;

-- admin nie moze updateowac kolumn sprzedane, data_wystawienia, kupione_przez_uid w tabeli aukcje
-- nie moze tez robic insert do tabeli aukcje
GRANT SELECT, UPDATE (aid, tytul, koniec_aukcji, wystawione_przez_uid, cena, sid,
                      czy_zatwierdzona), DELETE ON aukcje TO admin_group;

-- admin może CRUD na tabelach z paliwami oraz z nadwoziami
GRANT SELECT, UPDATE, INSERT, DELETE ON typ_paliwa, typ_nadwozia TO admin_group;
GRANT USAGE, SELECT ON SEQUENCE typ_paliwa_pid_seq TO admin_group;
GRANT USAGE, SELECT ON SEQUENCE typ_nadwozia_nid_seq TO admin_group;

-- admin nie może dodawac nowych samochodow
GRANT SELECT, UPDATE, DELETE ON samochody TO admin_group;

-- admin moze zarzadzac uzytkownikami
GRANT SELECT, INSERT, UPDATE, DELETE ON uzytkownicy TO admin_group;
GRANT USAGE, SELECT ON SEQUENCE uzytkownicy_uid_seq TO admin_group;
-- GRANT CREATE ON SCHEMA public TO admin_group;

-- admin moze usuwac uzytkownikow
GRANT EXECUTE ON FUNCTION usun_uzytkownika TO admin_group;

-- admin musi miec mozliwosc tworzenia POLICY (create policy...)
-- GRANT CREATE ON SCHEMA public TO admin_group;

-- admin moze ogladac wszystkie aukcje
GRANT SELECT ON wszystkie_aukcje_uprzywilejowany_dostep TO admin_group;

-- admin musi miec ADMIN OPTION w grupach klient_group, dealer_group, obsluga_group  (aby mogl innym nadawac te uprawnienia)
GRANT klient_group TO admin_group WITH ADMIN OPTION;
GRANT dealer_group TO admin_group WITH ADMIN OPTION;
GRANT obsluga_group TO admin_group WITH ADMIN OPTION;

-- admin moze dodawac nowych adminow, dealerow, obsluge oraz klientow
GRANT EXECUTE ON FUNCTION stworz_admina TO admin_group;
GRANT EXECUTE ON FUNCTION stworz_dealera TO admin_group;
GRANT EXECUTE ON FUNCTION stworz_obsluge TO admin_group;
GRANT EXECUTE ON FUNCTION stworz_klienta TO admin_group;

-- admin moze usuwac aukcje
GRANT EXECUTE ON FUNCTION usun_aukcje TO admin_group;

-- admin nie moze kupowac i wystawiac samochodow
REVOKE EXECUTE ON FUNCTION kup_samochod FROM admin_group;
REVOKE EXECUTE ON FUNCTION wystaw_samochod FROM admin_group;

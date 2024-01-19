CREATE ROLE klient_group;

GRANT SELECT ON moje_aktualne_aukcje TO klient_group;
GRANT SELECT ON moja_historia_aukcji TO klient_group;
GRANT SELECT ON otwarte_aukcje TO klient_group;
GRANT SELECT ON dane_samochodow TO klient_group;

GRANT EXECUTE ON FUNCTION kup_samochod TO klient_group;
GRANT EXECUTE ON FUNCTION wystaw_samochod TO klient_group;

-- klient moze usuwac swoje aukcje
GRANT EXECUTE ON FUNCTION usun_aukcje TO klient_group;

-- wystawianie aukcji
GRANT SELECT (uid, imie, nazwisko, login, nr_tel_publiczny, data_dolaczenia, typ_uzytkownika) ON uzytkownicy TO klient_group;

GRANT SELECT, INSERT (marka, model, rok_produkcji, przebieg, kolor_karoserii, pid, pojemnosc_baku, nid, nowy, powypadkowy, moc_silnika, spalanie, opis) ON samochody TO klient_group;
GRANT USAGE, SELECT ON SEQUENCE samochody_sid_seq TO klient_group;

GRANT INSERT (tytul, wystawione_przez_uid, cena, sid, koniec_aukcji), UPDATE (sprzedane, kupione_przez_uid), DELETE ON aukcje TO klient_group;
GRANT USAGE, SELECT ON SEQUENCE aukcje_aid_seq TO klient_group;

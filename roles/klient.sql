CREATE ROLE klient_group;

GRANT SELECT ON otwarte_aukcje TO klient_group;
GRANT ALL ON FUNCTION kup_samochod TO klient_group;
GRANT ALL ON FUNCTION wystaw_samochod TO klient_group;
GRANT ALL ON FUNCTION wyswietl_dane_samochodu TO klient_group;
GRANT ALL ON FUNCTION wyswietl_aktualne_aukcje_uzytkownika TO klient_group;
GRANT ALL ON FUNCTION wyswietl_historie_aukcji_uzytkownika TO klient_group;

CREATE ROLE dealer_group;

GRANT SELECT ON otwarte_aukcje TO dealer_group;
GRANT ALL ON FUNCTION kup_samochod TO dealer_group;
GRANT ALL ON FUNCTION wystaw_samochod TO dealer_group;
GRANT ALL ON FUNCTION wyswietl_dane_samochodu TO dealer_group;
GRANT ALL ON FUNCTION wyswietl_aktualne_aukcje_uzytkownika TO dealer_group;
GRANT ALL ON FUNCTION wyswietl_historie_aukcji_uzytkownika TO dealer_group;

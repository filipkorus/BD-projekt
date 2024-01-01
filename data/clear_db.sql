DROP VIEW IF EXISTS otwarte_aukcje;
DROP VIEW IF EXISTS wszystkie_aukcje_uprzywiledowany_dostep;

DROP TABLE IF EXISTS aukcje;
DROP TABLE IF EXISTS samochody;
DROP TABLE IF EXISTS uzytkownicy;
DROP TABLE IF EXISTS typ_nadwozia;
DROP TABLE IF EXISTS typ_paliwa;

DROP FUNCTION IF EXISTS ustaw_zatwierdzenie_dealera();
DROP TRIGGER IF EXISTS ustaw_zatwierdzenie_dealera_trigger on aukcje;

DROP FUNCTION IF EXISTS czy_uzytkownik_z_id_istnieje();
DROP FUNCTION IF EXISTS czy_uzytkownik_z_loginem_istnieje();
DROP FUNCTION IF EXISTS kup_samochod();
DROP FUNCTION IF EXISTS stworz_admina();
DROP FUNCTION IF EXISTS stworz_klienta();
DROP FUNCTION IF EXISTS walidacja_email();
DROP FUNCTION IF EXISTS walidacja_nr_tel();
DROP FUNCTION IF EXISTS wystaw_samochod();
DROP FUNCTION IF EXISTS wyswietl_aktualne_aukcje_uzytkownika();
DROP FUNCTION IF EXISTS wyswietl_dane_samochodu();
DROP FUNCTION IF EXISTS wyswietl_historie_aukcji_uzytkownika();

DROP OWNED BY admin_group;
DROP ROLE admin_group;

DROP OWNED BY klient_group;
DROP ROLE klient_group;

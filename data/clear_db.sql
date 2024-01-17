DROP TRIGGER IF EXISTS ustaw_zatwierdzenie_dealera_trigger on aukcje CASCADE;
DROP FUNCTION IF EXISTS ustaw_zatwierdzenie_dealera CASCADE;

DROP FUNCTION IF EXISTS stworz_admina CASCADE;
DROP FUNCTION IF EXISTS stworz_dealera CASCADE;
DROP FUNCTION IF EXISTS stworz_klienta CASCADE;
DROP FUNCTION IF EXISTS stworz_obsluge CASCADE;
DROP FUNCTION IF EXISTS usun_uzytkownika CASCADE;

DROP FUNCTION IF EXISTS czy_uzytkownik_z_id_istnieje CASCADE;
DROP FUNCTION IF EXISTS czy_uzytkownik_z_loginem_istnieje CASCADE;

DROP FUNCTION IF EXISTS walidacja_email CASCADE;
DROP FUNCTION IF EXISTS walidacja_nr_tel CASCADE;

DROP FUNCTION IF EXISTS kup_samochod CASCADE;
DROP FUNCTION IF EXISTS wystaw_samochod CASCADE;

DROP FUNCTION IF EXISTS usun_aukcje CASCADE;

DROP FUNCTION IF EXISTS wyswietl_aktualne_aukcje CASCADE;
DROP FUNCTION IF EXISTS wyswietl_dane_samochodu CASCADE;
DROP FUNCTION IF EXISTS wyswietl_historie_aukcji CASCADE;

DROP VIEW IF EXISTS otwarte_aukcje CASCADE;
DROP VIEW IF EXISTS wszystkie_aukcje_uprzywilejowany_dostep CASCADE;

DROP TABLE IF EXISTS aukcje CASCADE;
DROP TABLE IF EXISTS samochody CASCADE;
DROP TABLE IF EXISTS uzytkownicy CASCADE;
DROP TABLE IF EXISTS typ_nadwozia CASCADE;
DROP TABLE IF EXISTS typ_paliwa CASCADE;

DROP OWNED BY admin_group CASCADE;
DROP ROLE admin_group;

DROP OWNED BY klient_group CASCADE;
DROP ROLE klient_group;

DROP OWNED BY dealer_group CASCADE;
DROP ROLE dealer_group;

DROP OWNED BY obsluga_group CASCADE;
DROP ROLE obsluga_group;

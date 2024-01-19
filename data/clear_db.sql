DROP TRIGGER IF EXISTS ustaw_zatwierdzenie_dealera_trigger on aukcje CASCADE;
DROP FUNCTION IF EXISTS ustaw_zatwierdzenie_dealera CASCADE;

DROP TRIGGER IF EXISTS blokuj_zmiane_daty_wystawienia_trigger on aukcje CASCADE;
DROP FUNCTION IF EXISTS blokuj_zmiane_daty_wystawienia CASCADE;

DROP TRIGGER IF EXISTS blokuj_edycje_aukcji_po_sprzedazy_trigger on aukcje CASCADE;
DROP TRIGGER IF EXISTS blokuj_edycje_samochodow_po_sprzedazy_trigger on samochody CASCADE;
DROP FUNCTION IF EXISTS blokuj_edycje_aukcji_i_samochodow_po_sprzedazy CASCADE;

DROP TRIGGER IF EXISTS blokuj_edycje_nieswoich_aukcji_trigger on aukcje CASCADE;
DROP TRIGGER IF EXISTS blokuj_edycje_nieswoich_samochodow_trigger on samochody CASCADE;
DROP FUNCTION IF EXISTS blokuj_edycje_nieswoich_aukcji_i_samochodow CASCADE;

DROP TRIGGER IF EXISTS blokuj_kupowanie_samochodow_przez_admina_i_obsluge_trigger on aukcje CASCADE;
DROP FUNCTION IF EXISTS blokuj_kupowanie_samochodow_przez_admina_i_obsluge CASCADE;

DROP TRIGGER IF EXISTS blokuj_usuwanie_aukcji_po_sprzedazy_trigger on aukcje CASCADE;
DROP TRIGGER IF EXISTS blokuj_usuwanie_samochodow_po_sprzedazy_trigger on samochody CASCADE;
DROP FUNCTION IF EXISTS blokuj_usuwanie_aukcji_i_samochodow_po_sprzedazy CASCADE;

DROP TRIGGER IF EXISTS blokuj_usuwanie_nieswoich_aukcji_trigger on aukcje CASCADE;
DROP TRIGGER IF EXISTS blokuj_usuwanie_nieswoich_samochodow_trigger on samochody CASCADE;
DROP FUNCTION IF EXISTS blokuj_usuwanie_nieswoich_aukcji_i_samochodow CASCADE;

DROP TRIGGER IF EXISTS blokuj_wystawianie_samochodow_przez_admina_i_obsluge_trigger on aukcje CASCADE;
DROP FUNCTION IF EXISTS blokuj_wystawianie_samochodow_przez_admina_i_obsluge CASCADE;

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

DROP VIEW IF EXISTS dane_samochodow CASCADE;
DROP VIEW IF EXISTS moje_aktualne_aukcje CASCADE;
DROP VIEW IF EXISTS moja_historia_aukcji CASCADE;
DROP VIEW IF EXISTS otwarte_aukcje CASCADE;
DROP VIEW IF EXISTS wszystkie_aukcje_uprzywilejowany_dostep CASCADE;

DROP TABLE IF EXISTS aukcje CASCADE;
DROP TABLE IF EXISTS samochody CASCADE;
DROP TABLE IF EXISTS uzytkownicy CASCADE;
DROP TABLE IF EXISTS typ_nadwozia CASCADE;
DROP TABLE IF EXISTS typ_paliwa CASCADE;

-- remove all users with one of our four roles
DO
$$
    DECLARE
        username TEXT;
        role     TEXT;
    BEGIN
        FOR username, role IN (SELECT r.rolname, r1.rolname as role
                               FROM pg_catalog.pg_roles r
                                        LEFT JOIN pg_catalog.pg_auth_members m ON (m.member = r.oid)
                                        LEFT JOIN pg_roles r1 ON (m.roleid = r1.oid)
                               WHERE r.rolcanlogin
                               ORDER BY 1)
            LOOP
                IF role IN ('admin_group', 'klient_group', 'dealer_group', 'obsluga_group') THEN
                    EXECUTE 'DROP OWNED BY ' || username || ' CASCADE; DROP ROLE ' || username;
                END IF;
            END LOOP;
    END
$$;


DROP OWNED BY admin_group CASCADE;
DROP ROLE admin_group;

DROP OWNED BY klient_group CASCADE;
DROP ROLE klient_group;

DROP OWNED BY dealer_group CASCADE;
DROP ROLE dealer_group;

DROP OWNED BY obsluga_group CASCADE;
DROP ROLE obsluga_group;

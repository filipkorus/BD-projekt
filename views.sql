-- 1. WIDOK (dla zwykłego klienta): kto wystawia, parametry samochodu, do kiedy aukcja, cena
create view showing_all_auctions_opened as
select tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD')                                     AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')                                        AS "koniec aukcji",
       cena,
       login                                                                       AS "wystawione przez",
       email,
       (CASE WHEN nr_tel_publiczny THEN nr_tel ELSE 'Numer telefonu prywatny' END) AS "numer tel"
from aukcje
         inner join uzytkownicy on (wystawione_przez_uid = uid)
         inner join samochody using (sid)
where sprzedane = FALSE
  and (zatwierdzona_przez_pracownika = TRUE or zatwierdzona_przez_pracownika IS NULL);
--select * from showing_all_auctions_opened;
drop view showing_all_auctions_opened;

-- 2. WIDOK (dla admina/pracownika obslugi - czyli dodatkowo trzeba wyswietlic aukcje zwyklych klientow - te niezatwierdzone przez admina): kto wystawia, parametry samochodu, do kiedy aukcja, cena
create view showing_privileged_access as
select tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
       cena,
       login                                   AS "wystawione przez",
       email,
       nr_tel                                  AS "numer tel",
       zatwierdzona_przez_pracownika,
       sprzedane,
       CASE
           WHEN sprzedane THEN kupione_przez_uid
           ELSE NULL
           END                                 AS kupione_przez_uid
from aukcje
         inner join uzytkownicy on (wystawione_przez_uid = uid)
         inner join samochody using (sid);
--select * from showing_privileged_access;
drop view showing_privileged_access;

-- 3. WIDOK (diler ma miec mozliwosc wyswietlania swoich aktualnych aukcji) -- nie wiem jak zrobic to ze wysiwetla wlasne aukcje czy warunki są dobrze
create view showing_own_dealer_auctions as
select tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
       cena,
       sprzedane,
       zatwierdzona_przez_pracownika
from uzytkownicy
         cross join aukcje
where (sprzedane = FALSE and koniec_aukcji>now())
  and wystawione_przez_uid = uid
  and (typ_uzytkownika = 'dealer');
select * from showing_own_dealer_auctions;
drop view showing_own_dealer_auctions;

-- 4. WIDOK (diler ma miec mozliwosc wyswietlania swojej historii aukcji)
create view dealers_history_auctions as select tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
       cena,
       sprzedane,
       zatwierdzona_przez_pracownika
from uzytkownicy
         cross join aukcje
where wystawione_przez_uid = uid and ( sprzedane=TRUE or koniec_aukcji <now())
  and (typ_uzytkownika = 'dealer');
select * from dealers_history_auctions;
drop view dealers_history_auctions;
-- WIDOK (dla zwykłego klienta): kto wystawia, parametry samochodu, do kiedy aukcja, cena

create or replace view otwarte_aukcje as
select aid                                                                         AS "ID aukcji",
       tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD')                                     AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')                                        AS "koniec aukcji",
       cena,
       login                                                                       AS "wystawione przez",
       (CASE WHEN typ_uzytkownika = 'dealer' THEN 'dealer' ELSE 'osoba prywatna' END) AS "wystawiajacy",
       email,
       (CASE WHEN nr_tel_publiczny THEN nr_tel ELSE 'Numer telefonu prywatny' END) AS "numer tel"
from aukcje
         inner join uzytkownicy on (wystawione_przez_uid = uid)
         inner join samochody using (sid)
where sprzedane = FALSE
  and koniec_aukcji > NOW()
  and czy_zatwierdzona = TRUE;

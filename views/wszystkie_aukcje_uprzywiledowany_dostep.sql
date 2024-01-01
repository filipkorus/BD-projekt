-- WIDOK (dla admina/pracownika obslugi - czyli dodatkowo trzeba wyswietlic aukcje zwyklych klientow - te niezatwierdzone przez admina): kto wystawia, parametry samochodu, do kiedy aukcja, cena

create or replace view wszystkie_aukcje_uprzywiledowany_dostep as
select tytul,
       to_char(data_wystawienia, 'YYYY-MM-DD')                                   AS "data wystawienia",
       to_char(koniec_aukcji, 'YYYY-MM-DD')                                      AS "koniec aukcji",
       cena,
       login                                                                     AS "wystawione przez",
       (CASE WHEN typ_uzytkownika = 'dealer' THEN 'dealer' ELSE 'osoba prywatna' END) AS "wystawiajacy",
       email,
       nr_tel                                                                    AS "numer tel",
       czy_zatwierdzona,
       sprzedane,
       (CASE WHEN (sprzedane OR koniec_aukcji < NOW()) THEN TRUE ELSE FALSE END) AS "zakonczona",
       (CASE WHEN sprzedane THEN kupione_przez_uid END)                          AS kupione_przez_uid
from aukcje
         inner join uzytkownicy on (wystawione_przez_uid = uid)
         inner join samochody using (sid);

select *
from wszystkie_aukcje_uprzywiledowany_dostep;

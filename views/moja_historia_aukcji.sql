create or replace view moja_historia_aukcji as
select a.aid,
       a.tytul,
       to_char(a.data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
       to_char(a.koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
       a.cena,
       a.sprzedane,
       a.czy_zatwierdzona
from aukcje AS a
inner join uzytkownicy on uzytkownicy.uid=a.wystawione_przez_uid
where (a.sprzedane = TRUE or a.koniec_aukcji < now())
  and login = current_user;

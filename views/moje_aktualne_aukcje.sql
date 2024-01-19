create or replace view moje_aktualne_aukcje as
select a.aid,
       a.tytul,
       to_char(a.data_wystawienia, 'YYYY-MM-DD') AS "data wystawienia",
       to_char(a.koniec_aukcji, 'YYYY-MM-DD')    AS "koniec aukcji",
       a.cena,
       a.sprzedane,
       a.czy_zatwierdzona
from aukcje AS a
inner join uzytkownicy on uzytkownicy.uid=a.wystawione_przez_uid
where (a.sprzedane = FALSE and a.koniec_aukcji > now())
  and login = current_user;

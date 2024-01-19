create or replace view dane_samochodow as
select aid,
       s.marka,
       s.model,
       s.rok_produkcji,
       s.przebieg,
       tn.nazwa AS "typ nadwozia",
       tp.nazwa AS "typ paliwa",
       s.pojemnosc_baku,
       s.nowy,
       s.powypadkowy,
       s.moc_silnika,
       s.spalanie,
       s.opis
FROM samochody s
         INNER JOIN aukcje a ON s.sid = a.sid
         LEFT JOIN typ_nadwozia tn ON s.nid = tn.nid
         LEFT JOIN typ_paliwa tp ON s.pid = tp.pid
where czy_zatwierdzona = TRUE;

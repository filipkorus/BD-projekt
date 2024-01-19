# Testy bazy danych
Aby przeprowadzić testy należy dysponować 4 kontami z różnymi typami uprawnien (admin, obsluga_klienta, klient, dealer). Służą do tego funkcje `stworz_XXXXX`.
```postgresql
SELECT stworz_admina('admin1', 'qwerty', 'admin1', 'admin1', 'admin1@gmail.com', '987650182');
SELECT stworz_obsluge('obsluga1', 'qwerty', 'obsluga1', 'obsluga1', 'obsluga1@gmail.com', '987650181');
SELECT stworz_klienta('klient1', 'qwerty', 'klient1', 'klient1', 'klient1@gmail.com', '987650184');
SELECT stworz_dealera('dealer1', 'qwerty', 'dealer1', 'dealer1', 'dealer1@gmail.com', '987650189');
```
Po wykonaniu poleceń wyżej utworzone zostaną konta psql z różnymi typami uprawnień:
- login: `admin1`, hasło: `qwerty`
- login: `obsluga1`, hasło: `qwerty`
- login: `klient1`, hasło: `qwerty`
- login: `dealer1`, hasło: `qwerty`

## Tworzenie kont
Ani klient ani dealer samochodów nie mogą tworzyć nowych kont w serwisie. Dlatego z poziomu ich kont poniższe polecenia powinny zakończyć się błędem.
```postgresql
SELECT stworz_admina('adminek1', 'qwerty', 'Dobry', 'Admin', 'adminek1@gmail.com', '935226711');
SELECT stworz_obsluge('pani_krystynka1', 'qwerty', 'Krystyna', 'Kowalska', 'krysia1@gmail.com', '535225511');
SELECT stworz_klienta('adam_kos1', 'qwerty', 'Adam', 'Kos', 'adamkos1@gmail.com', '915286711');
SELECT stworz_dealera('janusz_szef1', 'qwerty', 'Janusz', 'Szef', 'januszszef1@gmail.com', '133921311');
```

Admin może tworzyć nowe konta każdego typu. Z poziomu konta admina poniższe polecenia powinny zakończyć się sukcesem.
```postgresql
SELECT stworz_admina('adminek2', 'qwerty', 'Dobry', 'Admin', 'adminek2@gmail.com', '935226712');
SELECT stworz_obsluge('pani_krystynka2', 'qwerty', 'Krystyna', 'Kowalska', 'krysia2@gmail.com', '535225512');
SELECT stworz_klienta('adam_kos2', 'qwerty', 'Adam', 'Kos', 'adamkos2@gmail.com', '915286712');
SELECT stworz_dealera('janusz_szef2', 'qwerty', 'Janusz', 'Szef', 'januszszef2@gmail.com', '133921312');
```

Pracownik obsługi klienta nie może tworzyć nowych kont dla admina lub pracownika obsługi klienta. Z poziomu konta obsługi klienta poniższe polecenia powinny zakończyć się błędem.
```postgresql
SELECT stworz_admina('adminek3', 'qwerty', 'Dobry', 'Admin', 'adminek3@gmail.com', '935226713');
SELECT stworz_obsluge('pani_krystynka3', 'qwerty', 'Krystyna', 'Kowalska', 'krysia3@gmail.com', '535225513');
```

Pracownik obsługi klienta może tworzyć nowe konta dla klientów oraz dealerów. Z poziomu konta obsługi klienta poniższe polecenia powinny zakończyć się sukcesem.
```postgresql
SELECT stworz_klienta('adam_kos4', 'qwerty', 'Adam', 'Kos', 'adamkos4@gmail.com', '915286714');
SELECT stworz_dealera('janusz_szef4', 'qwerty', 'Janusz', 'Szef', 'januszszef4@gmail.com', '133921314');
```

## Sprawdzanie poprawności formatu oraz unikalności adresu email oraz numeru telefonu.
Email dodawanego użytkownika musi być w odpowiednim formacie oraz musi być unikatowy, aby użytkownik został dodany. W bazie już istnieje użytkownik o emailu jankowalski@wp.pl, a pozostałe wywołania funkcji zawierają błędny format maila - operacja zakończy się niepowodzeniem.
```postgresql
SELECT stworz_klienta('janekjanekk','hasloadmin','Janek','Kowaluski','jankowalski@wp.pl','122000222');
SELECT stworz_klienta('niepowodzona','admin','Iga','Niepowodzona','zlyemail','122000722');
SELECT stworz_dealera('nieudanydiler','12admin','Mietek','Dlerski','dlerowi@@pl','122555333');
SELECT stworz_obsluge('ktosobslugowy','obslgua000','Dominika','Obsłuzniczka','111111111111','132555373');
SELECT stworz_admina('slabyadmin','12adminzly','Adrian','Minowy','slabiutko.1234','702555333');
```

Numer telefonu dodawanego użytkownika musi być w odpowiednim formacie oraz musi być unikatowy, aby użytkownik został dodany. W bazie już istnieje użytkownik o numerze 123456789, a pozostałe wywołania funkcji zawierają błędny format numeru - operacja zakończy się niepowodzeniem.
```postgresql
SELECT stworz_klienta('janekjanekk','hasloadmin','Janek','Kowaluski','jankowaluuski@wp.pl','123456789');
SELECT stworz_klienta('niepowodzona','admin','Iga','Niepowodzona','email@wm.pl','niedamcinumeru');
SELECT stworz_dealera('nieudanydiler','12admin','Mietek','Dlerski','dlerowi@pl.pl','12555333');
SELECT stworz_obsluge('ktosobslugowy','obslgua000','Dominika','Obsłuzniczka','domiobsluga@example.com','1325554944422373');
SELECT stworz_admina('slabyadmin','12adminzly','Adrian','Minowy','minek1233@wp.pl','7t2555333');
```

## Kupowanie samochodu na aukcji przez dwóch użytkowników
Dany samochód może zostać kupiony tylko raz, więc kto pierwszy ten lepszy.
```postgresql
SELECT kup_samochod(4); -- pierwsze wykonanie tej akcji powinno sie udac (jezeli aukcja nadal istnieje)
SELECT kup_samochod(4); -- aukcja z aid=4 zostala zakonczona
```

## Wyświetlanie danych samochodu
Wyświetlenie szczegółów samochodu wystawionego na aukcji powinno odbywać się poprzez widok dane_samochodow i podanie id aukcji (aid). Nie można wyświetlić szczegółów auta na aukcji, która nie istnieje. Następujące operacje mają zakończyć się niepowodzeniem
```postgresql
SELECT * FROM dane_samochodow WHERE aid=9999; -- nie ma samochodu z SID=9999
```

## Kupowanie samochodu
Kupno samochodu następuje przez funkcję kup_samochod. Użytkownik ma podać id aukcji, przez którą chce zakupić auto. Nie można kupić własnej aukcji, ani kupić aukcji która nie istnieje - operacja ma zakończyć się błędem.
Użytkownik z uid=1 wystawił aukcję z aid=1 - nie może jej kupić i następujące operacje powinny zakończyć się niepowodzeniem.
```postgresql
SELECT kup_samochod(999999); -- aukcja z aid=999999 nie istnieje - powinno zakonczyc sie bledem
SELECT kup_samochod(1); -- powinno kupic samochod z aid=1
```

## Pracownik obsługi klienta ani admin nie mogą kupować ani wystawiać żadnego samochodu
Poniższe polecenia z kont pracownika obsługi klienta oraz admina powinny zakończyć się błędem, natomiast powinny się udać z kont klienta oraz dealera.
```postgresql
SELECT wystaw_samochod('Fiat', 'Panda', 2002, 200000, 'czerwony', 1, 40, 1, FALSE, 75, 8, 'Super pandzioszka na sprzedaz', 'najlepsze auto pod sloncem', 7000, NOW()+INTERVAL '30 DAY', FALSE);
SELECT kup_samochod(4); -- UWAGA: danych samochod moze zostac kupiony tylko raz, wiec konieczne jest ponowne stworzenie aukcji
```

## Niezatwierdzone przez obsługę aukcje mają nie być widoczne dla innych użytkowników niebędących włascicielami
W widoku wyświetlanym poniżej nie powinna pokazać sią aukcja z aid=3, ponieważ nie została jeszcze zatwierdzona przez pracownika obsługi ani admina.
```postgresql
SELECT * FROM otwarte_aukcje;
```

## Próba usunięcia aukcji, która należy do innego użytkownika
Próba usunięcia aukcji przez klienta/dealera (do którego ta aukcja nie należy) powinna zakończyć się błędem. Natomiast admin/obsługa powinni mieć do tego prawo.
```postgresql
SELECT usun_aukcje(4); -- aukcja z aid=4 nalezy do innego uzytkownika
```

## Usuwanie/edycja danych aukcji/samochodu po jej zakończeniu
Żaden użytkownik (nawet admin oraz obsługa) nie ma prawa usunąć ani edytować danych aukcji ani samochodu z nią powiązanego po zakończeniu tej aukcji. Poniższe komendy powinny zakończyć się niepowodzeniem.
```postgresql
-- jesli aukcja z aid=4 nie została wcześniej zakupiona - proszę to zrobić
SELECT kup_samochod(4);

UPDATE aukcje SET sprzedane = FALSE, kupione_przez_uid = NULL WHERE sprzedane = TRUE;
DELETE FROM aukcje WHERE sprzedane = TRUE;
```

## Tabele typ_paliwa, typ_nadwozia
Usuwanie, dodawanie do tabel typ_paliwa i typ_nadwozia ma mieć tylko admin i obsługa. Gdy jako klient/dealer chcemy dodać pole do którejś z tych tabeli poniższe polecenia powinnny zakończyć się błędem informującym o braku uprawnień. Natomiast admin/obsługa powinny skutecznie wykonać te polecenia.
```postgresql
DELETE FROM typ_paliwa WHERE pid=2;
INSERT INTO typ_paliwa (nazwa) VALUES ('Pepsi');

DELETE FROM typ_nadwozia WHERE nid=4;
INSERT INTO typ_nadwozia (nazwa) VALUES ('Cola');
```

## Przy usuwaniu użytkownika mają się również usuwać jego aukcje
Użytkowników może usuwać tylko admin.
```postgresql
SELECT usun_uzytkownika('klientowyklient'); -- klientowyklient powinien zostac usuniety wraz ze swoimi aukcjami

SELECT * FROM aukcje LEFT JOIN uzytkownicy ON uzytkownicy.uid=aukcje.wystawione_przez_uid WHERE login='klientowyklient'; -- 0 rows
```

## Klient nie mogże zatwierdzić swojej własnej aukcji
Poniższa komenda nie powinna zadziałać.
```postgresql
UPDATE aukcje SET czy_zatwierdzona=TRUE WHERE wystawione_przez_uid=8; -- uzytkownik kliencik1 ma uid=8
```

## Admin oraz obsługa mogą zatwierdzać aukcje klientów
Poniższa komenda powinna zadziałać.
```postgresql
UPDATE aukcje SET czy_zatwierdzona=TRUE WHERE wystawione_przez_uid=8; -- uzytkownik kliencik1 ma uid=8
```

## Nie da się ingerować w datę dodania aukcji - jest ona automatycznie wpisywana przy dodawaniu aukcji.
Poniższa komenda nie powinna zadziałać.
```postgresql
UPDATE aukcje SET data_wystawienia = NOW() WHERE 1=1;
```

## Klient oraz dealer powininni widzieć wszystkie swoje aktualne aukcje - te zatwierdzone i niezatwierdzone
```postgresql
SELECT * FROM moje_aktualne_aukcje;
```

## Klient oraz dealer powininni widzieć wszystkie swoje zakończone aukcje
```postgresql
SELECT * FROM moja_historia_aukcji;
```

## Po zakupieniu samochodu nikt nie może edytować/usuwać aukcji ani powiązanego z nią samochodu
```postgresql
UPDATE aukcje SET sprzedane=FALSE AND kupione_przez_uid=NULL WHERE sprzedane=TRUE;

UPDATE samochody SET marka='nowa marka' FROM aukcje WHERE aukcje.sid=samochody.sid AND aukcje.sprzedane=TRUE;

DELETE FROM aukcje WHERE sprzedane=TRUE;

DELETE FROM samochody USING aukcje WHERE aukcje.sid=samochody.sid AND aukcje.sprzedane=TRUE;
```

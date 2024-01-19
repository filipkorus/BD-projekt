INSERT INTO typ_paliwa (nazwa)
VALUES ('Benzyna'),
       ('Benzyna+CNG'),
       ('Benzyna+LPG'),
       ('Diesel'),
       ('Elektryczny'),
       ('Etanol'),
       ('Hybryda'),
       ('Wodor');

INSERT INTO typ_nadwozia (nazwa, przyklad)
VALUES ('Auta male', 'Citroen C1, Fiat 500, Smart, Kia Picanto'),
       ('Auta miejskie', 'Opel Corsa, Ford Fiesta, Renault Clio'),
       ('Coupe', 'Audi A5, BMW 4, Ford Mustang'),
       ('Kabriolet', 'Mazda MX-5, Peugeot 207 CC, Porsche Boxster'),
       ('Kompakt', 'Volkswagen Golf, Ford Focus, Toyota Auris'),
       ('Kombi', 'Skoda Octavia Kombi, Audi A4 Avant, BMW 5 Touring'),
       ('Minivan', 'Renault Scenic, Citreon C4 Picasso, Opel Zafira'),
       ('Sedan', 'Volkswagen Passat, Opel Insignia, Mercedes Klasa C'),
       ('SUV', 'Volvo XC 60, Toyota RAV4, Kia Sportage');

SELECT stworz_klienta('jkowalski', 'qwerty', 'Jan', 'Kowalski', 'jankowalski@wp.pl', '123456789', TRUE);
SELECT stworz_dealera('anowak', 'qwerty', 'Anna', 'Nowak', 'anna.nowak@example.com', '987654321', FALSE);
SELECT stworz_klienta('amajewski', 'qwerty', 'Adam', 'Majewski', 'adam.majewski@example.com', '555666777', TRUE);
SELECT stworz_klienta('klientowyklient', 'qwerty', 'Krzyś', 'Kliencik', 'kliencikk@wp.pl', '222111333', FALSE);
SELECT stworz_dealera('znanykarolekdiler', 'qwerty', 'Karol', 'Znany', 'znanykadil@co.uk', '234679231', TRUE);

INSERT INTO samochody (marka, model, rok_produkcji, przebieg, kolor_karoserii, pid, pojemnosc_baku, nid, nowy,
                       powypadkowy, moc_silnika, spalanie, opis)
VALUES ('Volkswagen', 'Golf', 2019, 50000, 'Czarny', 1, 50, 5, FALSE, TRUE, 120, 6, 'Samochód w dobrym stanie.'),
       ('Ford', 'Mustang', 2022, 1000, 'Czerwony', 1, 60, 3, TRUE, NULL, 350, 12, 'Nowy model z silnikiem V8.'),
       ('Opel', 'Corsa', 2018, 30000, 'Biały', 2, 45, 2, FALSE, TRUE, 100, 5, 'Używany, lekkie ślady użytkowania.'),
       ('Fiat', 'Punto', 2015, 80000, 'Srebrny', 1, 40, 1, FALSE, TRUE, 80, 5,
        'Używane auto zadbane, regularnie serwisowane.'),
       ('Renault', 'Megane', 2005, 150000, 'Niebieski', 4, 55, 6, FALSE, TRUE, 90, 7,
        'Starsze auto, nadal w dobrym stanie.'),
       ('Fiat', 'Punto', 2015, 150000, 'Zielony', 1, 40, 1, FALSE, TRUE, 80, 5,
        'na zlom.'),
       ('Fiat', '500', 2019, 50000, 'Czarny', 1, 50, 1, FALSE, FALSE, 95, 7, 'polecam :)');

INSERT INTO aukcje (tytul, koniec_aukcji, wystawione_przez_uid, cena, sid, sprzedane, kupione_przez_uid)
VALUES ('VW Golf 2019', (NOW() + interval '30 day'), 1, 25000, 1, FALSE, NULL),
       ('Nowy Ford Mustang 2022', (NOW() + interval '45 day'), 2, 70000, 2, FALSE, NULL),
       ('Oapel Corsa 2018', (NOW() + interval '25 day'), 3, 15000, 3, FALSE, NULL),
       ('Wsyzstko ale nie stara renault ', ('2024-01-15'::timestamptz + interval '10 day'),
        2, 10000, 4, FALSE, NULL),
       ('stara rura fiat punto', (NOW() + interval '15 day'), 2, 222000, 5, TRUE, 1),
       ('punto do kasacji', (NOW() + interval '15 day'), 4, 500, 6, TRUE, 1),
       ('super Fiat 500', (NOW() + interval '15 day'), 5, 30000, 7, FALSE, NULL);

SET ROLE postgres;

SELECT stworz_admina('adminek', 'qwerty', 'Dobry', 'Admin', 'adminek@gmail.com', '935226719');

SET ROLE adminek;

SELECT stworz_obsluge('krystynka', 'qwerty', 'Dobra', 'Obsluga', 'krystynka@gmail.com', '235416719');
SELECT * FROM uzytkownicy;

SET ROLE krystynka;

SELECT usun_uzytkownika('adminek'); -- krystynka (obsluga) nie powinna miec prawa do usuniecia admina/obslugi
SELECT * FROM uzytkownicy;

-- SELECT stworz_klienta('kliencik', 'qwerty', 'Dobry', 'Klient', 'klient@gmail.com', '111222333');

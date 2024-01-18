SET ROLE admin;

-- SELECT stworz_admina('adminek', 'qwerty', 'Dobry', 'Admin', 'adminek@gmail.com', '935226719');
--
-- SET ROLE adminek;
--

--

-- SELECT * FROM aukcje;
-- SELECT usun_aukcje(6);
--
SET ROLE admin;
-- SELECT stworz_klienta('filip','filip','filip','filip','filip@gmail.com','123455432',FALSE);

-- SELECT stworz_admina('adminek','filip','filip','filip','adminek@gmail.com','123255432',FALSE);

-- SET ROLE filip;

SET role adminek;
-- SELECT * FROM otwarte_aukcje;

-- SELECT stworz_klienta('krystynka','krystynka','krystynka','krystynka','krystynka@gmail.com','723255432',FALSE);
SET role krystynka;
SELECT * FROM otwarte_aukcje;
-- SELECT usun_aukcje(4);
DELETE FROM aukcje WHERE aid=4;


-- SELECT wystaw_samochod('aaa','aaa',2002,200000,'czerwony', 1,55,1,TRUE,100,7,'aaaaaaaaa','aaa aaa 2002', 20000, NOW()+INTERVAL '30 DAY');

-- UPDATE aukcje SET sprzedane = TRUE, kupione_przez_uid=1 WHERE aid=4;
--
-- SELECT * FROM aukcje;

-- SELECT stworz_dealera('filip','filip','filip','filip','filip@gmail.com','123455432',FALSE);

-- REVOKE EXECUTE ON FUNCTION usun_aukcje FROM filip;
-- GRANT ALL ON FUNCTION wystaw_samochod TO filip;

-- SET ROLE filip;
--
--

-- SELECT stworz_admina('adminek', 'qwerty', 'Dobry', 'Admin', 'adminek@gmail.com', '935226719');
--
-- SET ROLE adminek;
--
-- SELECT stworz_obsluge('krystynka', 'qwerty', 'Dobra', 'Obsluga', 'krystynka@gmail.com', '235416719');
-- SELECT * FROM uzytkownicy;
--
-- SET ROLE krystynka;
--
-- SELECT usun_uzytkownika('adminek'); -- krystynka (obsluga) nie powinna miec prawa do usuniecia admina/obslugi
-- SELECT * FROM uzytkownicy;

-- SELECT stworz_klienta('kliencik', 'qwerty', 'Dobry', 'Klient', 'klient@gmail.com', '111222333');

SET ROLE postgres;

SELECT stworz_admina('adminek', 'qwerty', 'Dobry', 'Admin', 'adminek@gmail.com', '935226719');

SET ROLE adminek;
SELECT stworz_admina('adminek2', 'qwerty', 'Dobry', 'Admin', 'adminek2@gmail.com', '235426719');

SELECT stworz_klienta('kliencik', 'qwerty', 'Dobry', 'Klient', 'klient@gmail.com', '111222333');

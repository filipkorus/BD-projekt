$scriptRoot = "."

# Dodaj ścieżkę do katalogu bin PostgreSQL do zmiennej PATH
$env:PATH += ";C:\Program Files\PostgreSQL\15\bin"


# Dane do połączenia z bazą danych
$server = "10.0.1.1"
$database = "samochody"
$username = "admin"
$password ="admin"

# Ścieżki do plików SQL
$walidacjaEmail = Join-Path $scriptRoot "functions\walidacja_email.sql"
$walidacjaNrTel = Join-Path $scriptRoot "functions\walidacja_nr_tel.sql"
$clearDbScript = Join-Path $scriptRoot "data\clear_db.sql"
$createTablesScript = Join-Path $scriptRoot "create_tables.sql"
$checkingId = Join-Path $scriptRoot "functions\czy_uzytkownik_z_id_istnieje.sql"
$checkingLogin = Join-Path $scriptRoot "functions\czy_uzytkownik_z_loginem_istnieje.sql"
$deleteAuction = Join-Path $scriptRoot "functions\usun_aukcje.sql"
$buyCar = Join-Path $scriptRoot "functions\kup_samochod.sql"
$createAdmin = Join-Path $scriptRoot "functions\stworz_admina.sql"
$createDealer = Join-Path $scriptRoot "functions\stworz_dealera.sql"
$createObsluga = Join-Path $scriptRoot "functions\stworz_obsluge.sql"
$createClient = Join-Path $scriptRoot "functions\stworz_klienta.sql"
$deleteClient = Join-Path $scriptRoot "functions\usun_uzytkownika.sql"
$sellCar = Join-Path $scriptRoot "functions\wystaw_samochod.sql"
$showActualAuctions = Join-Path $scriptRoot "functions\wyswietl_aktualne_aukcje.sql"
$showDetails = Join-Path $scriptRoot "functions\wyswietl_dane_samochodu.sql"
$showHistory = Join-Path $scriptRoot "functions\wyswietl_historie_aukcji.sql"
$roleAdmin = Join-Path $scriptRoot "roles\admin.sql"
$roleObsluga= Join-Path $scriptRoot "roles\obsluga.sql"
$roleDealer= Join-Path $scriptRoot "roles\dealer.sql"
$roleClient = Join-Path $scriptRoot "roles\klient.sql"
$viewOpenAuctions = Join-Path $scriptRoot "views\otwarte_aukcje.sql"
$viewAllAuctionsPrivileged = Join-Path $scriptRoot "views\wszystkie_aukcje_uprzywilejowany_dostep.sql"
$triggerDealer = Join-Path $scriptRoot "triggers\ustaw_zatwierdzanie_dealera.sql"
$triggerAuction1 = Join-Path $scriptRoot "triggers\blokuj_zmiane_daty_wystawienia.sql"
$triggerAuction2 = Join-Path $scriptRoot "triggers\blokuj_edycje_aukcji_i_samochodow_po_sprzedazy.sql"
$triggerAuction3 = Join-Path $scriptRoot "triggers\blokuj_edycje_nieswoich_aukcji_i_samochodow.sql"
$triggerAuction4 = Join-Path $scriptRoot "triggers\blokuj_kupowanie_samochodow_przez_admina_i_obsluge.sql"
$triggerAuction5 = Join-Path $scriptRoot "triggers\blokuj_usuwanie_aukcji_i_samochodow_po_sprzedazy.sql"
$triggerAuction6 = Join-Path $scriptRoot "triggers\blokuj_usuwanie_nieswoich_aukcji_i_samochodow.sql"
$triggerAuction7 = Join-Path $scriptRoot "triggers\blokuj_wystawianie_samochodow_przez_admina_i_obsluge.sql"
$populateTablesScript = Join-Path $scriptRoot "data\populate_db.sql"

#$testRoles = Join-Path $scriptRoot "tests\roles.sql"

# Polecenie psql
#$psql = "psql -h $server -d $database -U $username  -f"
# Polecenie psql
#$psql = "psql -h $server -d $database -U $username -W $password -f"

$env:PGPASSWORD = $password
$psql = "psql -h $server -d $database -U $username -f"

# Wykonaj skrypty SQL po kolei
Invoke-Expression "$psql $clearDbScript"
Invoke-Expression "$psql $walidacjaEmail"
Invoke-Expression "$psql $walidacjaNrTel"
Invoke-Expression "$psql $createTablesScript"
Invoke-Expression "$psql $checkingId"
Invoke-Expression "$psql $checkingLogin"
Invoke-Expression "$psql $createAdmin"
Invoke-Expression "$psql $createDealer"
Invoke-Expression "$psql $createObsluga"
Invoke-Expression "$psql $createClient"
Invoke-Expression "$psql $deleteClient"
Invoke-Expression "$psql $deleteAuction"
Invoke-Expression "$psql $buyCar"
Invoke-Expression "$psql $sellCar"
Invoke-Expression "$psql $showActualAuctions"
Invoke-Expression "$psql $showDetails"
Invoke-Expression "$psql $showHistory"
Invoke-Expression "$psql $viewOpenAuctions"
Invoke-Expression "$psql $viewAllAuctionsPrivileged"
Invoke-Expression "$psql $triggerDealer"
Invoke-Expression "$psql $triggerAuction1"
Invoke-Expression "$psql $triggerAuction2"
Invoke-Expression "$psql $triggerAuction3"
Invoke-Expression "$psql $triggerAuction4"
Invoke-Expression "$psql $triggerAuction5"
Invoke-Expression "$psql $triggerAuction6"
Invoke-Expression "$psql $triggerAuction7"
Invoke-Expression "$psql $roleClient"
Invoke-Expression "$psql $roleDealer"
Invoke-Expression "$psql $roleObsluga"
Invoke-Expression "$psql $roleAdmin"
Invoke-Expression "$psql $populateTablesScript"

#Invoke-Expression "$psql $testRoles"

# Reset the PGPASSWORD environment variable after the script execution
Remove-Item Env:\PGPASSWORD

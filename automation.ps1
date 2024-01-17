$scriptRoot = "."

# Dodaj ścieżkę do katalogu bin PostgreSQL do zmiennej PATH
$env:PATH += ";C:\Program Files\PostgreSQL\15\bin"


# Dane do połączenia z bazą danych
$server = "localhost"
$database = "samochody"
$username = "postgres"
$password ="postgres"

# Ścieżki do plików SQL
$walidacjaEmail = Join-Path $scriptRoot "functions\walidacja_email.sql"
$walidacjaNrTel = Join-Path $scriptRoot "functions\walidacja_nr_tel.sql"
$clearDbScript = Join-Path $scriptRoot "data\clear_db.sql"
$createTablesScript = Join-Path $scriptRoot "create_tables.sql"
$populateTablesScript = Join-Path $scriptRoot "data\populate_db.sql"
$checkingId = Join-Path $scriptRoot "functions\czy_uzytkownik_z_id_istnieje.sql"
$checkingLogin = Join-Path $scriptRoot "functions\czy_uzytkownik_z_loginem_istnieje.sql"
$buyCar = Join-Path $scriptRoot "functions\kup_samochod.sql"
$createAdmin = Join-Path $scriptRoot "functions\stworz_admina.sql"
$createDealer = Join-Path $scriptRoot "functions\stworz_dealera.sql"
$createObsluga = Join-Path $scriptRoot "functions\stworz_obsluge.sql"
$createClient = Join-Path $scriptRoot "functions\stworz_klienta.sql"
$deleteClient = Join-Path $scriptRoot "functions\usun_uzytkownika.sql"
$sellCar = Join-Path $scriptRoot "functions\wystaw_samochod.sql"
$showActualAuctions = Join-Path $scriptRoot "functions\wyswietl_aktualne_aukcje_uzytkownika.sql"
$showDetails = Join-Path $scriptRoot "functions\wyswietl_dane_samochodu.sql"
$showHistory = Join-Path $scriptRoot "functions\wyswietl_historie_aukcji_uzytkownika.sql"
$roleAdmin = Join-Path $scriptRoot "roles\admin.sql"
$roleObsluga= Join-Path $scriptRoot "roles\obsluga.sql"
$roleDealer= Join-Path $scriptRoot "roles\dealer.sql"
$roleClient = Join-Path $scriptRoot "roles\klient.sql"
$viewOpenAuctions = Join-Path $scriptRoot "views\otwarte_aukcje.sql"
$viewAllAuctionsPrivileged = Join-Path $scriptRoot "views\wszystkie_aukcje_uprzywilejowany_dostep.sql"
$triggerDealer = Join-Path $scriptRoot "triggers\ustaw_zatwierdzanie_dealera.sql"

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
Invoke-Expression "$psql $populateTablesScript"
Invoke-Expression "$psql $checkingId"
Invoke-Expression "$psql $checkingLogin"
Invoke-Expression "$psql $createAdmin"
Invoke-Expression "$psql $createDealer"
Invoke-Expression "$psql $createObsluga"
Invoke-Expression "$psql $createClient"
Invoke-Expression "$psql $deleteClient"
Invoke-Expression "$psql $buyCar"
Invoke-Expression "$psql $sellCar"
Invoke-Expression "$psql $showActualAuctions"
Invoke-Expression "$psql $showDetails"
Invoke-Expression "$psql $showHistory"
Invoke-Expression "$psql $viewOpenAuctions"
Invoke-Expression "$psql $viewAllAuctionsPrivileged"
Invoke-Expression "$psql $triggerDealer"
Invoke-Expression "$psql $roleClient"
Invoke-Expression "$psql $roleDealer"
Invoke-Expression "$psql $roleObsluga"
Invoke-Expression "$psql $roleAdmin"

#Invoke-Expression "$psql $testRoles"

# Reset the PGPASSWORD environment variable after the script execution
Remove-Item Env:\PGPASSWORD

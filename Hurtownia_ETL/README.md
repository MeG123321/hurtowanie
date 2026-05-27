# Hurtownia_ETL

Odtworzony proces zasilenia hurtowni z 3 źródeł MS Access:

- `Baza Finanse i Czas_M.accdb`
- `Baza Finanse i Czas_B.accdb`
- `Baza Finanse i Czas_D.accdb`

## Założenia

- źródła są ładowane **osobno** (kolumna `source_system`: `M`, `B`, `D`),
- najpierw ładowane są **wymiary**, potem **fakty**,
- rozwiązanie jest reproducowalne przez skrypty SQL (Visual Studio / SSMS / SQLCMD).

## Struktura

- `sql/01_create_staging_and_helpers.sql` – obiekty ETL i tabele staging
- `sql/02_stage_access_sources.sql` – import danych z trzech plików Access do staging
- `sql/03_load_dimensions.sql` – zasilenie tabel wymiarów
- `sql/04_load_facts.sql` – zasilenie tabel faktów
- `sql/05_run_full_load.sql` – pełne uruchomienie (kolejność: staging -> dimensions -> facts)

## Wymagania środowiskowe

1. SQL Server z dostępem do hurtowni.
2. Zainstalowany provider Access OLE DB (Microsoft Access Database Engine, np. `Microsoft.ACE.OLEDB.16.0`).
3. Włączone ad hoc queries (`OPENROWSET`) na instancji SQL Server.

## Konfiguracja

W skrypcie `02_stage_access_sources.sql` ustaw ścieżki:

- `@PathM`
- `@PathB`
- `@PathD`

Domyślnie skrypt zakłada, że nazwy tabel w Access odpowiadają używanym przez ETL tabelom stagingowym.
Jeśli w Access nazwy/kolumny różnią się, zmodyfikuj sekcję `INSERT ... SELECT` w tym skrypcie.

## Uruchomienie

Uruchamiaj skrypty w kolejności:

1. `01_create_staging_and_helpers.sql`
2. `02_stage_access_sources.sql`
3. `03_load_dimensions.sql`
4. `04_load_facts.sql`

lub jednorazowo:

5. `05_run_full_load.sql`

## Kolejność logiczna ładowania

Wymiary (najpierw):

- `D_TYP_WYKSZTALCENIA`
- `D_TYP_MIEJSCOWOSCI`
- `D_TYP_WYDATKU`
- `D_DATA`
- `D_FORMA_PLATNOSCI`
- `D_TYP_PRZYCHODU`
- `D_AKTYWNOSC`
- `D_OSOBA`
- `D_MIEJSCOWOSC`
- `D_KATEGORIA_WYDATKU`

Fakty (na końcu):

- `F_WYDATEK`
- `F_PRZYCHOD`
- `F_CZAS`

## Visual Studio

Repo zawiera też projekt SSIS (`Integration Services Project1`) jako punkt startowy do dalszej rozbudowy pakietu.
W praktyce zasilenie można uruchamiać od razu skryptami SQL z tego katalogu.

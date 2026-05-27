# ETL z trzech baz MS Access do hurtowni

Projekt `Hurtownia_ETL` ładuje dane do istniejącej hurtowni `FinanseCzas_DW` z trzech niezależnych plików źródłowych:

- `Baza Finanse i Czas_B.accdb`
- `Baza Finanse i Czas_D.accdb`
- `Baza Finanse i Czas_M.accdb`

## Konfiguracja źródeł

Domyślne połączenia Access są ustawione na ścieżki względne:

- `./Sources/Baza Finanse i Czas_B.accdb`
- `./Sources/Baza Finanse i Czas_D.accdb`
- `./Sources/Baza Finanse i Czas_M.accdb`

Umieść pliki `.accdb` w katalogu `Hurtownia_ETL/Sources/` albo podmień wartości parametrów `CM.Baza Finanse i Czas_*.accdb.ConnectionString` w konfiguracji projektu SSIS.

## Kolejność ładowania (Control Flow)

Pakiet `Package.dtsx` wymusza kolejność przez `Precedence Constraints`:

1. `słowniki` (wymiary słownikowe)
2. `Zasilanie_Osoby` (wymiar osób)
3. `Zasilanie_Przychodow` (fakt przychodów)
4. `Fakt_Wydatki` (fakt wydatków)
5. `Fakt_Aktywnosc_Czas` (fakt czasu)

Czyli najpierw ładowane są wymiary, a następnie fakty.

## Mapowanie i transformacje

### Wymiary

- `słowniki`:
  - `TYP_MIEJSCOWOŚCI` (B/D/M) -> `Dim_Miejscowosc`
  - `TYP_AKTYWNOSCI` (B/D/M) -> `Dim_Aktywnosc`
  - `TYP_PRZYCHODU` (B/D/M) -> `Dim_Typ_Przychodu`
  - `TYP_WYDATKU` (B/D/M) -> `Dim_Kategoria_Wydatku`
  - transformacje: `Union All` + `Sort (Distinct)` w celu scalenia trzech źródeł i deduplikacji.
- `Zasilanie_Osoby`:
  - `OSOBA` + `TYP_WYKSZTAŁCENIA` (B/D/M) -> `Dim_Osoba`
  - transformacje: `Union All` (scalenie danych osobowych z 3 baz).

### Fakty

- `Zasilanie_Przychodow`:
  - `PRZYCHÓD` + `OSOBA` (B/D/M) -> `Fakt_Przychody`
  - lookupy: `Dim_Data`, `Dim_Osoba`.
- `Fakt_Wydatki`:
  - `WYDATEK` + `OSOBA` (B/D/M) -> `Fakt_Wydatki`
  - lookupy: `Dim_Data`, `Dim_Osoba`, `Dim_Kategoria_Wydatku`, `Dim_Forma_Platnosci`, `Dim_Miejscowosc`.
- `Fakt_Aktywnosc_Czas`:
  - `CZAS` + `OSOBA` (B/D/M) -> `Fakt_Aktywnosc_Czas`
  - lookupy: `Dim_Data`, `Dim_Osoba`.

## Uruchomienie

1. Upewnij się, że `FinanseCzas_DW` istnieje i ma docelowy schemat.
2. (Opcjonalnie) uruchom `sql/01_reset_load_tables.sql`.
3. Otwórz `Hurtownia_ETL.sln` w Visual Studio (SSIS).
4. Zweryfikuj połączenie do SQL Server (`.\\SQLEXPRESS` domyślnie).
5. Uruchom `Package.dtsx`.

Po wykonaniu pakiet scali dane z trzech baz Access do jednej hurtowni.

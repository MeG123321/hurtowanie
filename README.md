# hurtowanie

Repozytorium odtworzone po wyczyszczeniu – zawiera gotowy, reproducowalny proces zasilenia hurtowni z 3 baz Access:

- `Baza Finanse i Czas_M.accdb`
- `Baza Finanse i Czas_B.accdb`
- `Baza Finanse i Czas_D.accdb`

Główne artefakty ETL znajdują się w katalogu:

- [`/Hurtownia_ETL`](./Hurtownia_ETL)

Najważniejszy plik do uruchomienia pełnego procesu:

- [`Hurtownia_ETL/sql/05_run_full_load.sql`](./Hurtownia_ETL/sql/05_run_full_load.sql)

Kolejność ładowania jest zachowana: najpierw wymiary, potem fakty.

/*
  Pełne uruchomienie ETL:
  1) przygotowanie obiektów staging
  2) import z Access (M/B/D)
  3) ładowanie wymiarów
  4) ładowanie faktów

  UWAGA: skrypt używa komend :r (SQLCMD mode).
*/

:r .\01_create_staging_and_helpers.sql
:r .\02_stage_access_sources.sql
:r .\03_load_dimensions.sql
:r .\04_load_facts.sql

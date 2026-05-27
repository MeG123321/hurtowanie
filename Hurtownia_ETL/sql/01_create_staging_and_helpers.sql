/*
  Tworzy schemat ETL i tabele staging.
  Skrypt idempotentny - można uruchamiać wielokrotnie.
*/

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'etl')
    EXEC('CREATE SCHEMA etl');
GO

IF OBJECT_ID('etl.stg_typ_wyksztalcenia','U') IS NULL
CREATE TABLE etl.stg_typ_wyksztalcenia (
    source_system CHAR(1) NOT NULL,
    typ_wyksztalcenia NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_typ_miejscowosci','U') IS NULL
CREATE TABLE etl.stg_typ_miejscowosci (
    source_system CHAR(1) NOT NULL,
    typ_miejscowosci NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_typ_wydatku','U') IS NULL
CREATE TABLE etl.stg_typ_wydatku (
    source_system CHAR(1) NOT NULL,
    typ_wydatku NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_data','U') IS NULL
CREATE TABLE etl.stg_data (
    source_system CHAR(1) NOT NULL,
    data_kalendarzowa DATE NOT NULL
);
GO

IF OBJECT_ID('etl.stg_forma_platnosci','U') IS NULL
CREATE TABLE etl.stg_forma_platnosci (
    source_system CHAR(1) NOT NULL,
    forma_platnosci NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_typ_przychodu','U') IS NULL
CREATE TABLE etl.stg_typ_przychodu (
    source_system CHAR(1) NOT NULL,
    typ_przychodu NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_aktywnosc','U') IS NULL
CREATE TABLE etl.stg_aktywnosc (
    source_system CHAR(1) NOT NULL,
    aktywnosc NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('etl.stg_osoba','U') IS NULL
CREATE TABLE etl.stg_osoba (
    source_system CHAR(1) NOT NULL,
    imie NVARCHAR(200) NOT NULL,
    nazwisko NVARCHAR(200) NOT NULL,
    plec NVARCHAR(50) NULL,
    typ_wyksztalcenia NVARCHAR(200) NULL
);
GO

IF OBJECT_ID('etl.stg_miejscowosc','U') IS NULL
CREATE TABLE etl.stg_miejscowosc (
    source_system CHAR(1) NOT NULL,
    miejscowosc NVARCHAR(200) NOT NULL,
    typ_miejscowosci NVARCHAR(200) NULL
);
GO

IF OBJECT_ID('etl.stg_kategoria_wydatku','U') IS NULL
CREATE TABLE etl.stg_kategoria_wydatku (
    source_system CHAR(1) NOT NULL,
    kategoria_wydatku NVARCHAR(200) NOT NULL,
    typ_wydatku NVARCHAR(200) NULL
);
GO

IF OBJECT_ID('etl.stg_f_wydatek','U') IS NULL
CREATE TABLE etl.stg_f_wydatek (
    source_system CHAR(1) NOT NULL,
    data_kalendarzowa DATE NOT NULL,
    imie NVARCHAR(200) NOT NULL,
    nazwisko NVARCHAR(200) NOT NULL,
    miejscowosc NVARCHAR(200) NOT NULL,
    forma_platnosci NVARCHAR(200) NULL,
    kategoria_wydatku NVARCHAR(200) NULL,
    kwota DECIMAL(18,2) NOT NULL,
    liczba_wydatkow INT NULL
);
GO

IF OBJECT_ID('etl.stg_f_przychod','U') IS NULL
CREATE TABLE etl.stg_f_przychod (
    source_system CHAR(1) NOT NULL,
    data_kalendarzowa DATE NOT NULL,
    imie NVARCHAR(200) NOT NULL,
    nazwisko NVARCHAR(200) NOT NULL,
    miejscowosc NVARCHAR(200) NOT NULL,
    typ_przychodu NVARCHAR(200) NULL,
    kwota DECIMAL(18,2) NOT NULL,
    liczba_przychodow INT NULL
);
GO

IF OBJECT_ID('etl.stg_f_czas','U') IS NULL
CREATE TABLE etl.stg_f_czas (
    source_system CHAR(1) NOT NULL,
    data_kalendarzowa DATE NOT NULL,
    imie NVARCHAR(200) NOT NULL,
    nazwisko NVARCHAR(200) NOT NULL,
    miejscowosc NVARCHAR(200) NOT NULL,
    aktywnosc NVARCHAR(200) NULL,
    liczba_godzin DECIMAL(10,2) NOT NULL,
    liczba_wpisow INT NULL
);
GO

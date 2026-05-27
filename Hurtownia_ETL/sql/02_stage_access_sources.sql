/*
  Import danych z 3 osobnych plików Access do tabel staging.
  Uwaga: Wymaga OPENROWSET i providera Microsoft.ACE.OLEDB.16.0
*/

SET NOCOUNT ON;

DECLARE @PathM NVARCHAR(4000) = N'C:\ETL\Sources\Baza Finanse i Czas_M.accdb';
DECLARE @PathB NVARCHAR(4000) = N'C:\ETL\Sources\Baza Finanse i Czas_B.accdb';
DECLARE @PathD NVARCHAR(4000) = N'C:\ETL\Sources\Baza Finanse i Czas_D.accdb';

DECLARE @Sources TABLE (source_system CHAR(1), file_path NVARCHAR(4000));
INSERT INTO @Sources(source_system, file_path)
VALUES ('M', @PathM), ('B', @PathB), ('D', @PathD);

TRUNCATE TABLE etl.stg_typ_wyksztalcenia;
TRUNCATE TABLE etl.stg_typ_miejscowosci;
TRUNCATE TABLE etl.stg_typ_wydatku;
TRUNCATE TABLE etl.stg_data;
TRUNCATE TABLE etl.stg_forma_platnosci;
TRUNCATE TABLE etl.stg_typ_przychodu;
TRUNCATE TABLE etl.stg_aktywnosc;
TRUNCATE TABLE etl.stg_osoba;
TRUNCATE TABLE etl.stg_miejscowosc;
TRUNCATE TABLE etl.stg_kategoria_wydatku;
TRUNCATE TABLE etl.stg_f_wydatek;
TRUNCATE TABLE etl.stg_f_przychod;
TRUNCATE TABLE etl.stg_f_czas;

DECLARE @source_system CHAR(1);
DECLARE @file_path NVARCHAR(4000);
DECLARE @sql NVARCHAR(MAX);

DECLARE source_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT source_system, file_path FROM @Sources;

OPEN source_cursor;
FETCH NEXT FROM source_cursor INTO @source_system, @file_path;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'
INSERT INTO etl.stg_typ_wyksztalcenia(source_system, typ_wyksztalcenia)
SELECT ''' + @source_system + ''', CAST(typ_wyksztalcenia AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT typ_wyksztalcenia FROM D_TYP_WYKSZTALCENIA'');

INSERT INTO etl.stg_typ_miejscowosci(source_system, typ_miejscowosci)
SELECT ''' + @source_system + ''', CAST(typ_miejscowosci AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT typ_miejscowosci FROM D_TYP_MIEJSCOWOSCI'');

INSERT INTO etl.stg_typ_wydatku(source_system, typ_wydatku)
SELECT ''' + @source_system + ''', CAST(typ_wydatku AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT typ_wydatku FROM D_TYP_WYDATKU'');

INSERT INTO etl.stg_data(source_system, data_kalendarzowa)
SELECT ''' + @source_system + ''', CAST(data_kalendarzowa AS DATE)
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT data_kalendarzowa FROM D_DATA'');

INSERT INTO etl.stg_forma_platnosci(source_system, forma_platnosci)
SELECT ''' + @source_system + ''', CAST(forma_platnosci AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT forma_platnosci FROM D_FORMA_PLATNOSCI'');

INSERT INTO etl.stg_typ_przychodu(source_system, typ_przychodu)
SELECT ''' + @source_system + ''', CAST(typ_przychodu AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT typ_przychodu FROM D_TYP_PRZYCHODU'');

INSERT INTO etl.stg_aktywnosc(source_system, aktywnosc)
SELECT ''' + @source_system + ''', CAST(aktywnosc AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT aktywnosc FROM D_AKTYWNOSC'');

INSERT INTO etl.stg_osoba(source_system, imie, nazwisko, plec, typ_wyksztalcenia)
SELECT ''' + @source_system + ''', CAST(imie AS NVARCHAR(200)), CAST(nazwisko AS NVARCHAR(200)), CAST(plec AS NVARCHAR(50)), CAST(typ_wyksztalcenia AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT imie, nazwisko, plec, typ_wyksztalcenia FROM D_OSOBA'');

INSERT INTO etl.stg_miejscowosc(source_system, miejscowosc, typ_miejscowosci)
SELECT ''' + @source_system + ''', CAST(miejscowosc AS NVARCHAR(200)), CAST(typ_miejscowosci AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT miejscowosc, typ_miejscowosci FROM D_MIEJSCOWOSC'');

INSERT INTO etl.stg_kategoria_wydatku(source_system, kategoria_wydatku, typ_wydatku)
SELECT ''' + @source_system + ''', CAST(kategoria_wydatku AS NVARCHAR(200)), CAST(typ_wydatku AS NVARCHAR(200))
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT kategoria_wydatku, typ_wydatku FROM D_KATEGORIA_WYDATKU'');

INSERT INTO etl.stg_f_wydatek(source_system, data_kalendarzowa, imie, nazwisko, miejscowosc, forma_platnosci, kategoria_wydatku, kwota, liczba_wydatkow)
SELECT ''' + @source_system + ''', CAST(data_kalendarzowa AS DATE), CAST(imie AS NVARCHAR(200)), CAST(nazwisko AS NVARCHAR(200)), CAST(miejscowosc AS NVARCHAR(200)), CAST(forma_platnosci AS NVARCHAR(200)), CAST(kategoria_wydatku AS NVARCHAR(200)), CAST(kwota AS DECIMAL(18,2)), CAST(liczba_wydatkow AS INT)
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT data_kalendarzowa, imie, nazwisko, miejscowosc, forma_platnosci, kategoria_wydatku, kwota, liczba_wydatkow FROM F_WYDATEK'');

INSERT INTO etl.stg_f_przychod(source_system, data_kalendarzowa, imie, nazwisko, miejscowosc, typ_przychodu, kwota, liczba_przychodow)
SELECT ''' + @source_system + ''', CAST(data_kalendarzowa AS DATE), CAST(imie AS NVARCHAR(200)), CAST(nazwisko AS NVARCHAR(200)), CAST(miejscowosc AS NVARCHAR(200)), CAST(typ_przychodu AS NVARCHAR(200)), CAST(kwota AS DECIMAL(18,2)), CAST(liczba_przychodow AS INT)
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT data_kalendarzowa, imie, nazwisko, miejscowosc, typ_przychodu, kwota, liczba_przychodow FROM F_PRZYCHOD'');

INSERT INTO etl.stg_f_czas(source_system, data_kalendarzowa, imie, nazwisko, miejscowosc, aktywnosc, liczba_godzin, liczba_wpisow)
SELECT ''' + @source_system + ''', CAST(data_kalendarzowa AS DATE), CAST(imie AS NVARCHAR(200)), CAST(nazwisko AS NVARCHAR(200)), CAST(miejscowosc AS NVARCHAR(200)), CAST(aktywnosc AS NVARCHAR(200)), CAST(liczba_godzin AS DECIMAL(10,2)), CAST(liczba_wpisow AS INT)
FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Data Source=' + REPLACE(@file_path,'''','''''') + ';Persist Security Info=False;'', ''SELECT data_kalendarzowa, imie, nazwisko, miejscowosc, aktywnosc, liczba_godzin, liczba_wpisow FROM F_CZAS'');
';

    EXEC sys.sp_executesql @sql;
    FETCH NEXT FROM source_cursor INTO @source_system, @file_path;
END;

CLOSE source_cursor;
DEALLOCATE source_cursor;

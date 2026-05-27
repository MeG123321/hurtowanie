/*
  Ładowanie wymiarów - zawsze przed faktami.
  Założenie: tabele docelowe D_* istnieją już w hurtowni.
*/

SET NOCOUNT ON;

INSERT INTO D_TYP_WYKSZTALCENIA(typ_wyksztalcenia)
SELECT DISTINCT s.typ_wyksztalcenia
FROM etl.stg_typ_wyksztalcenia s
WHERE NOT EXISTS (
    SELECT 1 FROM D_TYP_WYKSZTALCENIA d WHERE d.typ_wyksztalcenia = s.typ_wyksztalcenia
);

INSERT INTO D_TYP_MIEJSCOWOSCI(typ_miejscowosci)
SELECT DISTINCT s.typ_miejscowosci
FROM etl.stg_typ_miejscowosci s
WHERE NOT EXISTS (
    SELECT 1 FROM D_TYP_MIEJSCOWOSCI d WHERE d.typ_miejscowosci = s.typ_miejscowosci
);

INSERT INTO D_TYP_WYDATKU(typ_wydatku)
SELECT DISTINCT s.typ_wydatku
FROM etl.stg_typ_wydatku s
WHERE NOT EXISTS (
    SELECT 1 FROM D_TYP_WYDATKU d WHERE d.typ_wydatku = s.typ_wydatku
);

INSERT INTO D_DATA(data_kalendarzowa, dzien, miesiac, kwartal, rok)
SELECT DISTINCT
       s.data_kalendarzowa,
       DATEPART(DAY, s.data_kalendarzowa),
       DATEPART(MONTH, s.data_kalendarzowa),
       DATEPART(QUARTER, s.data_kalendarzowa),
       DATEPART(YEAR, s.data_kalendarzowa)
FROM etl.stg_data s
WHERE NOT EXISTS (
    SELECT 1 FROM D_DATA d WHERE d.data_kalendarzowa = s.data_kalendarzowa
);

INSERT INTO D_FORMA_PLATNOSCI(forma_platnosci)
SELECT DISTINCT s.forma_platnosci
FROM etl.stg_forma_platnosci s
WHERE NOT EXISTS (
    SELECT 1 FROM D_FORMA_PLATNOSCI d WHERE d.forma_platnosci = s.forma_platnosci
);

INSERT INTO D_TYP_PRZYCHODU(typ_przychodu)
SELECT DISTINCT s.typ_przychodu
FROM etl.stg_typ_przychodu s
WHERE NOT EXISTS (
    SELECT 1 FROM D_TYP_PRZYCHODU d WHERE d.typ_przychodu = s.typ_przychodu
);

INSERT INTO D_AKTYWNOSC(aktywnosc)
SELECT DISTINCT s.aktywnosc
FROM etl.stg_aktywnosc s
WHERE NOT EXISTS (
    SELECT 1 FROM D_AKTYWNOSC d WHERE d.aktywnosc = s.aktywnosc
);

INSERT INTO D_OSOBA(imie, nazwisko, plec, typ_wyksztalcenia_id)
SELECT DISTINCT s.imie, s.nazwisko, s.plec, tw.typ_wyksztalcenia_id
FROM etl.stg_osoba s
LEFT JOIN D_TYP_WYKSZTALCENIA tw
    ON tw.typ_wyksztalcenia = s.typ_wyksztalcenia
WHERE NOT EXISTS (
    SELECT 1
    FROM D_OSOBA d
    WHERE d.imie = s.imie
      AND d.nazwisko = s.nazwisko
      AND ISNULL(d.plec,'') = ISNULL(s.plec,'')
);

INSERT INTO D_MIEJSCOWOSC(miejscowosc, typ_miejscowosci_id)
SELECT DISTINCT s.miejscowosc, tm.typ_miejscowosci_id
FROM etl.stg_miejscowosc s
LEFT JOIN D_TYP_MIEJSCOWOSCI tm
    ON tm.typ_miejscowosci = s.typ_miejscowosci
WHERE NOT EXISTS (
    SELECT 1 FROM D_MIEJSCOWOSC d WHERE d.miejscowosc = s.miejscowosc
);

INSERT INTO D_KATEGORIA_WYDATKU(kategoria_wydatku, typ_wydatku_id)
SELECT DISTINCT s.kategoria_wydatku, tw.typ_wydatku_id
FROM etl.stg_kategoria_wydatku s
LEFT JOIN D_TYP_WYDATKU tw
    ON tw.typ_wydatku = s.typ_wydatku
WHERE NOT EXISTS (
    SELECT 1 FROM D_KATEGORIA_WYDATKU d WHERE d.kategoria_wydatku = s.kategoria_wydatku
);

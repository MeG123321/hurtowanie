/*
  Ładowanie tabel faktów po zasileniu wymiarów.
*/

SET NOCOUNT ON;

INSERT INTO F_WYDATEK(data_id, osoba_id, miejscowosc_id, forma_platnosci_id, kategoria_wydatku_id, kwota, liczba_wydatkow)
SELECT
    d.data_id,
    o.osoba_id,
    m.miejscowosc_id,
    fp.forma_platnosci_id,
    kw.kategoria_wydatku_id,
    s.kwota,
    COALESCE(s.liczba_wydatkow, 1)
FROM etl.stg_f_wydatek s
JOIN D_DATA d ON d.data_kalendarzowa = s.data_kalendarzowa
JOIN D_OSOBA o ON o.imie = s.imie AND o.nazwisko = s.nazwisko
JOIN D_MIEJSCOWOSC m ON m.miejscowosc = s.miejscowosc
LEFT JOIN D_FORMA_PLATNOSCI fp ON fp.forma_platnosci = s.forma_platnosci
LEFT JOIN D_KATEGORIA_WYDATKU kw ON kw.kategoria_wydatku = s.kategoria_wydatku;

INSERT INTO F_PRZYCHOD(data_id, osoba_id, miejscowosc_id, typ_przychodu_id, kwota, liczba_przychodow)
SELECT
    d.data_id,
    o.osoba_id,
    m.miejscowosc_id,
    tp.typ_przychodu_id,
    s.kwota,
    COALESCE(s.liczba_przychodow, 1)
FROM etl.stg_f_przychod s
JOIN D_DATA d ON d.data_kalendarzowa = s.data_kalendarzowa
JOIN D_OSOBA o ON o.imie = s.imie AND o.nazwisko = s.nazwisko
JOIN D_MIEJSCOWOSC m ON m.miejscowosc = s.miejscowosc
LEFT JOIN D_TYP_PRZYCHODU tp ON tp.typ_przychodu = s.typ_przychodu;

INSERT INTO F_CZAS(data_id, osoba_id, miejscowosc_id, aktywnosc_id, liczba_godzin, liczba_wpisow)
SELECT
    d.data_id,
    o.osoba_id,
    m.miejscowosc_id,
    a.aktywnosc_id,
    s.liczba_godzin,
    COALESCE(s.liczba_wpisow, 1)
FROM etl.stg_f_czas s
JOIN D_DATA d ON d.data_kalendarzowa = s.data_kalendarzowa
JOIN D_OSOBA o ON o.imie = s.imie AND o.nazwisko = s.nazwisko
JOIN D_MIEJSCOWOSC m ON m.miejscowosc = s.miejscowosc
LEFT JOIN D_AKTYWNOSC a ON a.aktywnosc = s.aktywnosc;

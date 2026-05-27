-- Opcjonalne czyszczenie tabel ładowanych przez Package.dtsx.
-- Zachowuje istniejący schemat hurtowni (bez zmian DDL).

BEGIN TRY
    BEGIN TRAN;

    -- Fakty najpierw
    DELETE FROM dbo.Fakt_Aktywnosc_Czas;
    DELETE FROM dbo.Fakt_Wydatki;
    DELETE FROM dbo.Fakt_Przychody;

    -- Potem wymiary ładowane przez pakiet
    DELETE FROM dbo.Dim_Osoba;
    DELETE FROM dbo.Dim_Miejscowosc;
    DELETE FROM dbo.Dim_Aktywnosc;
    DELETE FROM dbo.Dim_Typ_Przychodu;
    DELETE FROM dbo.Dim_Kategoria_Wydatku;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;
    THROW;
END CATCH;

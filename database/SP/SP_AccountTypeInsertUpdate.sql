CREATE OR ALTER PROCEDURE SP_AccountTypeInsertUpdate
    @AccountTypeName VARCHAR(50),
    @Description     VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate BEFORE touching the database or opening a transaction
    IF @AccountTypeName IS NULL OR LTRIM(RTRIM(@AccountTypeName)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM AccountType WHERE AccountTypeName = @AccountTypeName)
        BEGIN
            SELECT 0 AS StatusCode, 'ACCOUNT TYPE ALREADY EXISTS' AS Message;
            RETURN;
        END

        BEGIN TRANSACTION;

        INSERT INTO AccountType (
          AccountTypeName, 
          Description)
        VALUES (
          @AccountTypeName, 
          @Description);

        COMMIT TRANSACTION;

        SELECT 1 AS StatusCode, 'DATA INSERTED SUCCESSFULLY' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 0 AS StatusCode,
               ERROR_MESSAGE() AS Message,
               ERROR_NUMBER() AS ErrorNumber,
               ERROR_LINE() AS ErrorLine,
               ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH
END

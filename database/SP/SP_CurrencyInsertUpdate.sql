CREATE OR ALTER PROCEDURE SP_CurrencyInsertUpdate
    @CurrencyCode VARCHAR(3),
    @CurrencyName VARCHAR(50),
    @Symbol       VARCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate BEFORE touching the database or opening a transaction
    IF @CurrencyCode IS NULL OR LTRIM(RTRIM(@CurrencyCode)) = ''
       OR @CurrencyName IS NULL OR LTRIM(RTRIM(@CurrencyName)) = ''
       OR @Symbol IS NULL OR LTRIM(RTRIM(@Symbol)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Currency WHERE CurrencyCode = @CurrencyCode)
        BEGIN
            SELECT 0 AS StatusCode, 'CURRENCY ALREADY EXISTS' AS Message;
            RETURN;
        END

        BEGIN TRANSACTION;

        INSERT INTO Currency (
            CurrencyCode,
            CurrencyName,
            Symbol,
            UpdatedAt,
            IsActive
        )
        VALUES (
            @CurrencyCode,
            @CurrencyName,
            @Symbol,
            GETDATE(),
            1
        );

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

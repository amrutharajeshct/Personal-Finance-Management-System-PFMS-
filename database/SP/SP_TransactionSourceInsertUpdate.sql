CREATE OR ALTER PROCEDURE SP_TransactionSourceInsertUpdate
    @TransactionSourceName VARCHAR(50)   -- Manual / Import / Recurring
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @TransactionSourceName IS NULL OR LTRIM(RTRIM(@TransactionSourceName)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TransactionSource WHERE TransactionSourceName = @TransactionSourceName)
        BEGIN
            SELECT 0 AS StatusCode, 'TRANSACTION SOURCE ALREADY EXISTS' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO TransactionSource (
            TransactionSourceName,
            UpdatedAt,
            IsActive
        )
        VALUES (
            @TransactionSourceName,
            NULL,
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
GO

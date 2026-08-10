CREATE OR ALTER PROCEDURE SP_TransactionTypeInsertUpdate
    @TransactionTypeName VARCHAR(10),   -- 'Income' or 'Expense'
    @Description         VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @TransactionTypeName IS NULL OR LTRIM(RTRIM(@TransactionTypeName)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    IF @TransactionTypeName NOT IN ('Income', 'Expense')
    BEGIN
        SELECT 0 AS StatusCode, 'TRANSACTION TYPE NAME MUST BE INCOME OR EXPENSE' AS Message;
        RETURN;
    END
 
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TransactionType WHERE TransactionTypeName = @TransactionTypeName)
        BEGIN
            SELECT 0 AS StatusCode, 'TRANSACTION TYPE ALREADY EXISTS' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO TransactionType (
            TransactionTypeName,
            Description,
            IsActive,
            UpdatedAt
        )
        VALUES (
            @TransactionTypeName,
            @Description,
            1,
            NULL
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

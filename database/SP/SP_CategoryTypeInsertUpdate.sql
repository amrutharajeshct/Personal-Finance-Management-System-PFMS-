CREATE OR ALTER PROCEDURE SP_CategoryTypeInsertUpdate
    @CategoryTypeName VARCHAR(10)   -- 'Income' or 'Expense'
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @CategoryTypeName IS NULL OR LTRIM(RTRIM(@CategoryTypeName)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    IF @CategoryTypeName NOT IN ('Income', 'Expense')
    BEGIN
        SELECT 0 AS StatusCode, 'CATEGORY TYPE NAME MUST BE INCOME OR EXPENSE' AS Message;
        RETURN;
    END
 
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM CategoryType WHERE CategoryTypeName = @CategoryTypeName)
        BEGIN
            SELECT 0 AS StatusCode, 'CATEGORY TYPE ALREADY EXISTS' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO CategoryType (
            CategoryTypeName,
            UpdatedAt,
            IsActive
        )
        VALUES (
            @CategoryTypeName,
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

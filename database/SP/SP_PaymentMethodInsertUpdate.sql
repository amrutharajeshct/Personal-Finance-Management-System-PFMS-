CREATE OR ALTER PROCEDURE SP_PaymentMethodInsertUpdate
    @PaymentMethodName VARCHAR(50),   -- Cash / UPI / Debit Card / Bank Transfer (BR-021)
    @Description       VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @PaymentMethodName IS NULL OR LTRIM(RTRIM(@PaymentMethodName)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM PaymentMethod WHERE PaymentMethodName = @PaymentMethodName)
        BEGIN
            SELECT 0 AS StatusCode, 'PAYMENT METHOD ALREADY EXISTS' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO PaymentMethod (
            PaymentMethodName,
            Description,
            IsActive,
            UpdatedAt
        )
        VALUES (
            @PaymentMethodName,
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

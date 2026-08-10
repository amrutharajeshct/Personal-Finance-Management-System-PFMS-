CREATE OR ALTER PROCEDURE SP_AccountInsertUpdate
    @UserID          INT,
    @AccountName     VARCHAR(100),
    @AccountTypeID   INT,
    @CurrencyID      INT = NULL,   -- defaults to INR in V1
    @OpeningBalance  DECIMAL(18,2),
    @AccountNumber   VARCHAR(30) = NULL,  -- NULL for Cash-type accounts
    @IFSCCode        VARCHAR(15) = NULL,  -- NULL for Cash-type accounts
    @BankName        VARCHAR(100) = NULL  -- NULL for Cash-type accounts
AS
BEGIN
    SET NOCOUNT ON;
 
    -- Validate BEFORE touching the database or opening a transaction
    IF @UserID IS NULL
       OR @AccountName IS NULL OR LTRIM(RTRIM(@AccountName)) = ''
       OR @AccountTypeID IS NULL
       OR @OpeningBalance IS NULL
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    -- Default CurrencyID to INR if not supplied (BR: defaults to INR in V1)
    IF @CurrencyID IS NULL
    BEGIN
        SELECT @CurrencyID = CurrencyID FROM Currency WHERE CurrencyCode = 'INR';
    END
 
    BEGIN TRY
        -- AccountTypeID must exist
        IF NOT EXISTS (SELECT 1 FROM AccountType WHERE AccountTypeID = @AccountTypeID AND IsActive = 1)
        BEGIN
            SELECT 0 AS StatusCode, 'INVALID OR INACTIVE ACCOUNT TYPE' AS Message;
            RETURN;
        END
 
        -- CurrencyID must exist (after default resolution)
        IF @CurrencyID IS NULL OR NOT EXISTS (SELECT 1 FROM Currency WHERE CurrencyID = @CurrencyID AND IsActive = 1)
        BEGIN
            SELECT 0 AS StatusCode, 'INVALID OR INACTIVE CURRENCY' AS Message;
            RETURN;
        END
 
        -- AccountName must be unique (per BR-009)
        IF EXISTS (SELECT 1 FROM Account WHERE AccountName = @AccountName)
        BEGIN
            SELECT 0 AS StatusCode, 'ACCOUNT NAME ALREADY EXISTS' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO Account (
            UserID,
            AccountName,
            AccountTypeID,
            CurrencyID,
            OpeningBalance,
            AccountNumber,
            IFSCCode,
            BankName,
            IsActive,
            CreatedAt,
            UpdatedAt
        )
        VALUES (
            @UserID,
            @AccountName,
            @AccountTypeID,
            @CurrencyID,
            @OpeningBalance,
            @AccountNumber,
            @IFSCCode,
            @BankName,
            1,
            GETDATE(),
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

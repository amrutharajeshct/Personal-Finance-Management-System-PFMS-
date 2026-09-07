CREATE OR ALTER PROCEDURE SP_IncomeInsertUpdate
    @UserID          INT,
    @AccountID       INT,
    @CategoryID      INT,
    @Amount          DECIMAL(18,2),
    @IncomeDate      DATETIME,
    @Description     VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate BEFORE touching the database or opening a transaction
    IF @UserID IS NULL
       OR @AccountID IS NULL
       OR @CategoryID IS NULL
       OR @Amount IS NULL
       OR @IncomeDate IS NULL
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END

    IF @Amount <= 0
    BEGIN
        SELECT 0 AS StatusCode, 'AMOUNT MUST BE GREATER THAN ZERO' AS Message;
        RETURN;
    END

    BEGIN TRY
        -- AccountID must exist and belong to this user
        IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountID = @AccountID AND UserID = @UserID AND IsActive = 1)
        BEGIN
            SELECT 0 AS StatusCode, 'INVALID OR INACTIVE ACCOUNT' AS Message;
            RETURN;
        END

        -- CategoryID must exist and be an Income-type category
        IF NOT EXISTS (
            SELECT 1
            FROM Category c
            JOIN CategoryType ct ON ct.CategoryTypeID = c.CategoryTypeID
            WHERE c.CategoryID = @CategoryID
              AND c.IsActive = 1
              AND ct.CategoryTypeName = 'Income'
        )
        BEGIN
            SELECT 0 AS StatusCode, 'INVALID OR INACTIVE INCOME CATEGORY' AS Message;
            RETURN;
        END

        BEGIN TRANSACTION;

        INSERT INTO Income (
            UserID,
            AccountID,
            CategoryID,
            Amount,
            IncomeDate,
            Description,
            IsActive,
            CreatedAt,
            UpdatedAt
        )
        VALUES (
            @UserID,
            @AccountID,
            @CategoryID,
            @Amount,
            @IncomeDate,
            @Description,
            1,
            GETDATE(),
            NULL
        );

        -- Keep the account balance in sync with the recorded income
        UPDATE Account
        SET OpeningBalance = OpeningBalance + @Amount,
            UpdatedAt = GETDATE()
        WHERE AccountID = @AccountID;

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

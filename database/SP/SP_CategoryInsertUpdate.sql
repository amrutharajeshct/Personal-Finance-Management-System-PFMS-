CREATE OR ALTER PROCEDURE SP_CategoryInsertUpdate
    @CategoryName     VARCHAR(100),
    @CategoryTypeID   INT,
    @ParentCategoryID INT = NULL   -- one level only (BR-019)
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @CategoryName IS NULL OR LTRIM(RTRIM(@CategoryName)) = ''
       OR @CategoryTypeID IS NULL
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END
 
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM CategoryType WHERE CategoryTypeID = @CategoryTypeID AND IsActive = 1)
        BEGIN
            SELECT 0 AS StatusCode, 'INVALID OR INACTIVE CATEGORY TYPE' AS Message;
            RETURN;
        END
 
        -- Enforce "one level only": a parent category cannot itself have a parent
        IF @ParentCategoryID IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Category WHERE CategoryID = @ParentCategoryID AND IsActive = 1)
            BEGIN
                SELECT 0 AS StatusCode, 'INVALID OR INACTIVE PARENT CATEGORY' AS Message;
                RETURN;
            END
 
            IF EXISTS (SELECT 1 FROM Category WHERE CategoryID = @ParentCategoryID AND ParentCategoryID IS NOT NULL)
            BEGIN
                SELECT 0 AS StatusCode, 'PARENT CATEGORY CANNOT BE A SUB-CATEGORY (ONE LEVEL ONLY)' AS Message;
                RETURN;
            END
        END
 
        -- Uniqueness is scoped to CategoryTypeID (BR-016)
        IF EXISTS (
            SELECT 1 FROM Category
            WHERE CategoryName = @CategoryName
              AND CategoryTypeID = @CategoryTypeID
        )
        BEGIN
            SELECT 0 AS StatusCode, 'CATEGORY NAME ALREADY EXISTS FOR THIS CATEGORY TYPE' AS Message;
            RETURN;
        END
 
        BEGIN TRANSACTION;
 
        INSERT INTO Category (
            CategoryName,
            CategoryTypeID,
            ParentCategoryID,
            IsActive,
            CreatedAt,
            UpdatedAt
        )
        VALUES (
            @CategoryName,
            @CategoryTypeID,
            @ParentCategoryID,
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
 
 

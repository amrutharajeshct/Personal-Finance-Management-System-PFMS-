CREATE OR ALTER PROCEDURE SP_Signup
    @Mode         INT,
    @FullName     VARCHAR(150),
    @MobileNumber VARCHAR(15),
    @Address      VARCHAR(255),
    @Email        VARCHAR(150),
    @CreatedAt    DATETIME,
    @UserName     VARCHAR(100),
    @PasswordHash VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserID INT;

    -- Validate BEFORE touching the database or opening a transaction
    IF @FullName IS NULL OR LTRIM(RTRIM(@FullName)) = ''
       OR @UserName IS NULL OR LTRIM(RTRIM(@UserName)) = ''
       OR @MobileNumber IS NULL OR LTRIM(RTRIM(@MobileNumber)) = ''
    BEGIN
        SELECT 0 AS StatusCode, 'PROVIDE ALL REQUIRED DETAILS' AS Message;
        RETURN;
    END

    BEGIN TRY
        IF @Mode = 1
        BEGIN
            -- USER CHECKING
            IF EXISTS (SELECT 1 FROM UserDetails WHERE FullName = @FullName AND MobileNumber = @MobileNumber AND Email = @Email)
            BEGIN
                SELECT 0 AS StatusCode, 'USER ALREADY EXISTS' AS Message;
                RETURN;
            END

            -- USERNAME CHECKING
            IF EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
            BEGIN
                SELECT 0 AS StatusCode, 'USERNAME ALREADY EXISTS' AS Message;
                RETURN;
            END

            BEGIN TRANSACTION;

            INSERT INTO UserDetails (
                FullName,
                MobileNumber,
                Address,
                Email,
                CreatedAt
            )
            VALUES (
                @FullName,
                @MobileNumber,
                @Address,
                @Email,
                @CreatedAt
            );

            SET @UserID = SCOPE_IDENTITY();   -- TO GET THE SAME UserID

            INSERT INTO Users (
                UserID,
                UserName,
                PasswordHash,
                CreatedAt
            )
            VALUES (
                @UserID,
                @UserName,
                @PasswordHash,
                @CreatedAt
            );

            COMMIT TRANSACTION;

            SELECT 1 AS StatusCode, 'USER REGISTERED SUCCESSFULLY' AS Message;
            RETURN;
        END

        IF @Mode = 2
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
            BEGIN
                SELECT 0 AS StatusCode, 'USERNAME NOT EXISTS' AS Message;
                RETURN;
            END

            BEGIN TRANSACTION;

            UPDATE UserDetails
            SET FullName     = @FullName,
                MobileNumber = @MobileNumber,
                Address      = @Address,
                Email        = @Email
            WHERE UserName = @UserName;

            UPDATE Users
            SET PasswordHash = @PasswordHash
            WHERE UserName = @UserName;

            COMMIT TRANSACTION;

            SELECT 1 AS StatusCode, 'USER DATA UPDATED SUCCESSFULLY' AS Message;
            RETURN;
        END

        -- Neither Mode 1 nor Mode 2: always return a result set
        SELECT 0 AS StatusCode, 'INVALID MODE' AS Message;
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

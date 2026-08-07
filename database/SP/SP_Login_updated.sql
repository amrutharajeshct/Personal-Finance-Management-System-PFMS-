CREATE OR ALTER PROCEDURE SP_Login
    @UserName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Only looks up the account and returns its stored hash.
        -- Actual password verification happens in the app layer via
        -- PasswordHelper.VerifyPassword, since PBKDF2 uses a per-user
        -- salt and can't be compared with simple SQL equality.
        SELECT
            UserID,
            UserName,
            PasswordHash,
            IsActive
        FROM Users
        WHERE UserName = @UserName;

    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER()    AS ErrorNumber,
            ERROR_MESSAGE()   AS ErrorMessage,
            ERROR_LINE()      AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH
END

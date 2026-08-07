CREATE OR ALTER PROCEDURE SP_Signup(
  @FullName	VARCHAR(150),
  @MobileNumber	VARCHAR(15),
  @Address	VARCHAR(255),
  @Email	VARCHAR(150),
  @CreatedAt	DATETIME,
  @UserName VARCHAR(100),
  @PasswordHash VARCHAR(256)
)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @UserID INT;
  BEGIN TRY
    IF  @FullName IS NULL OR @UserName IS NULL   -- VALIDATING MANDATORY FIELDS
        BEGIN
        SELECT 0 AS StatusCode,
        'PROVIDE ALL REQUIRED DETAILS' AS Message;
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        RETURN;
        END

      -- USER CHECKING
    IF EXISTS (SELECT 1 FROM UserDetails WHERE FullName=@FullName AND MobileNumber=@MobileNumber AND Email=@Email)
      BEGIN
        SELECT
          0 AS StatusCode,
          'USER ALREADY EXISTS' AS Message;
        RETURN;
      END

        -- USERNAME CHECKING
    IF EXISTS (SELECT 1 FROM Users WHERE UserName=@UserName)
      BEGIN
        SELECT
          0 AS StatusCode,
          'USERNAME ALREADY EXISTS' AS Message;
        RETURN;
      END

        
    BEGIN TRANSACTION


            INSERT INTO UserDetails(
              FullName,
              MobileNumber,
              Address,
              Email,
              CreatedAt          
            )
            VALUES(@FullName,
              @MobileNumber,
              @Address,
              @Email,
              @CreatedAt
            )
      SET @UserID = SCOPE_IDENTITY();   -- TO GET THE SAME UserID
          
            INSERT INTO Users(
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
            )
            COMMIT TRANSACTION
          SELECT
            1 AS StatusCode,
            'USER REGISTERED SUCCESSFULLY' AS Message;

        
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;
    select 
      ERROR_NUMBER() AS ErrorNumber,
      ERROR_MESSAGE() AS ErrorMessage,
      ERROR_LINE() AS ErrorLine,
      ERROR_PROCEDURE() AS ErrorProcedure;

  END CATCH
END

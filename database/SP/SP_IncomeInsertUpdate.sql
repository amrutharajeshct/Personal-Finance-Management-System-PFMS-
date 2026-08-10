CREATE OR ALTER PROCEDURE SP_IncomeInsertUpdate
  @AccountID	INT,
  @UserID	INT,
  @AccountName	VARCHAR(100),
  @AccountTypeID	INT,
  @CurrencyID	INT,
  @OpeningBalance	DECIMAL(18,2),
  @AccountNumber	VARCHAR(30),
  @IFSCCode	VARCHAR(15),
  @BankName	VARCHAR(100)
AS 
BEGIN 
  BEGIN TRY
    IF EXISTS(SELECT 1 FROM Account WHERE AccountName=@AccountName)
    BEGIN 
      SELECT 1 AS STATUS,'ACCOUNT ALREADY EXISTS' AS MESSAGE
    END
  BEGIN TRANSACTION
    IF @AccountName IS NULL OR AccountTypeID IS NULL
    BEGIN
      SELECT 0 AS StatusCode,
        'PROVIDE ALL REQUIRED DETAILS' AS Message;
    END 
    ELSE
      BEGIN
        INSERT INTO Account(
          UserID,
          AccountName,
          AccountTypeID,
          CurrencyID,
          OpeningBalance,
          AccountNumber,
          IFSCCode,
          BankName
        )
        VALUES(
          @UserID,
          @AccountName,
          @AccountTypeID,
          @CurrencyID,
          @OpeningBalance,
          @AccountNumber,
          @IFSCCode,
          @BankName
        )
      END

  END TRY
  BEGIN CATCH

  END CATCH
END

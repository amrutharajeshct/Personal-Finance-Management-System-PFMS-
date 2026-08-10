/* =========================================================================
   TEST SCRIPT — Run procedures in this order (respects FK dependencies)
   Currency -> AccountType -> Account
   CategoryType -> Category
   PaymentMethod
   TransactionType
   TransactionSource
   ========================================================================= */


/* -------------------------------------------------------------------------
   1. Currency  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success: insert INR
EXEC SP_CurrencyInsertUpdate
    @CurrencyCode = 'INR',
    @CurrencyName = 'Indian Rupee',
    @Symbol       = N'₹';

-- Success: insert USD
EXEC SP_CurrencyInsertUpdate
    @CurrencyCode = 'USD',
    @CurrencyName = 'US Dollar',
    @Symbol       = '$';

-- Failure: duplicate CurrencyCode
EXEC SP_CurrencyInsertUpdate
    @CurrencyCode = 'INR',
    @CurrencyName = 'Indian Rupee Duplicate',
    @Symbol       = N'₹';

-- Failure: missing required field (blank CurrencyName)
EXEC SP_CurrencyInsertUpdate
    @CurrencyCode = 'EUR',
    @CurrencyName = '',
    @Symbol       = N'€';

-- Sanity check
SELECT * FROM Currency;


/* -------------------------------------------------------------------------
   2. AccountType  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success: insert Savings
EXEC SP_AccountTypeInsertUpdate
    @AccountTypeName = 'Savings',
    @Description     = 'Standard savings bank account';

-- Success: insert Cash
EXEC SP_AccountTypeInsertUpdate
    @AccountTypeName = 'Cash',
    @Description     = 'Physical cash in hand';

-- Success: insert Credit Card
EXEC SP_AccountTypeInsertUpdate
    @AccountTypeName = 'Credit Card',
    @Description     = 'Credit card liability account';

-- Failure: duplicate AccountTypeName
EXEC SP_AccountTypeInsertUpdate
    @AccountTypeName = 'Savings',
    @Description     = 'Duplicate attempt';

-- Failure: missing required field
EXEC SP_AccountTypeInsertUpdate
    @AccountTypeName = NULL,
    @Description     = 'No name provided';

-- Sanity check
SELECT * FROM AccountType;


/* -------------------------------------------------------------------------
   3. Account  (depends on: a User row must already exist, AccountType, Currency)
      NOTE: Adjust @UserID below to an ID that actually exists in your User table.
   ------------------------------------------------------------------------- */

-- Success: bank account, explicit CurrencyID (INR)
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = 'Federal Bank Savings',
    @AccountTypeID  = 1,              -- Savings (adjust to actual generated ID)
    @CurrencyID     = 1,              -- INR (adjust to actual generated ID)
    @OpeningBalance = 25000.00,
    @AccountNumber  = '1234567890',
    @IFSCCode       = 'FDRL0001234',
    @BankName       = 'Federal Bank';

-- Success: cash account, CurrencyID omitted (should default to INR)
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = 'Wallet Cash',
    @AccountTypeID  = 2,              -- Cash
    @OpeningBalance = 500.00,
    @AccountNumber  = NULL,
    @IFSCCode       = NULL,
    @BankName       = NULL;

-- Failure: duplicate AccountName
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = 'Wallet Cash',
    @AccountTypeID  = 2,
    @OpeningBalance = 1000.00;

-- Failure: invalid AccountTypeID
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = 'Bad Account Type Test',
    @AccountTypeID  = 9999,
    @OpeningBalance = 1000.00;

-- Failure: invalid CurrencyID
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = 'Bad Currency Test',
    @AccountTypeID  = 1,
    @CurrencyID     = 9999,
    @OpeningBalance = 1000.00;

-- Failure: missing required field
EXEC SP_AccountInsertUpdate
    @UserID         = 1,
    @AccountName    = NULL,
    @AccountTypeID  = 1,
    @OpeningBalance = 1000.00;

-- Sanity check
SELECT * FROM Account;


/* -------------------------------------------------------------------------
   4. CategoryType  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success
EXEC SP_CategoryTypeInsertUpdate @CategoryTypeName = 'Income';
EXEC SP_CategoryTypeInsertUpdate @CategoryTypeName = 'Expense';

-- Failure: duplicate
EXEC SP_CategoryTypeInsertUpdate @CategoryTypeName = 'Income';

-- Failure: invalid domain value
EXEC SP_CategoryTypeInsertUpdate @CategoryTypeName = 'Transfer';

-- Failure: missing required field
EXEC SP_CategoryTypeInsertUpdate @CategoryTypeName = NULL;

-- Sanity check
SELECT * FROM CategoryType;


/* -------------------------------------------------------------------------
   5. Category  (depends on CategoryType, optionally on Category itself)
      NOTE: Adjust @CategoryTypeID below to actual generated IDs.
   ------------------------------------------------------------------------- */

-- Success: top-level category under Expense
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Food & Dining',
    @CategoryTypeID   = 2,      -- Expense (adjust to actual generated ID)
    @ParentCategoryID = NULL;

-- Success: another top-level category under Expense
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Transportation',
    @CategoryTypeID   = 2,
    @ParentCategoryID = NULL;

-- Success: sub-category under Food & Dining (assume it got CategoryID = 1)
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Groceries',
    @CategoryTypeID   = 2,
    @ParentCategoryID = 1;      -- adjust to actual Food & Dining CategoryID

-- Success: top-level category under Income
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Salary',
    @CategoryTypeID   = 1,      -- Income
    @ParentCategoryID = NULL;

-- Failure: duplicate name within same CategoryTypeID
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Food & Dining',
    @CategoryTypeID   = 2,
    @ParentCategoryID = NULL;

-- Success (allowed): same name but under a DIFFERENT CategoryTypeID
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Food & Dining',
    @CategoryTypeID   = 1,      -- Income — different type, so name reuse is fine
    @ParentCategoryID = NULL;

-- Failure: two-level nesting attempt (Groceries already has a parent, so it can't become one)
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Vegetables',
    @CategoryTypeID   = 2,
    @ParentCategoryID = 3;      -- adjust to actual Groceries CategoryID

-- Failure: invalid CategoryTypeID
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Bad Type Test',
    @CategoryTypeID   = 9999,
    @ParentCategoryID = NULL;

-- Failure: invalid ParentCategoryID
EXEC SP_CategoryInsertUpdate
    @CategoryName     = 'Bad Parent Test',
    @CategoryTypeID   = 2,
    @ParentCategoryID = 9999;

-- Failure: missing required field
EXEC SP_CategoryInsertUpdate
    @CategoryName     = NULL,
    @CategoryTypeID   = 2,
    @ParentCategoryID = NULL;

-- Sanity check
SELECT * FROM Category;


/* -------------------------------------------------------------------------
   6. PaymentMethod  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = 'Cash',          @Description = 'Physical cash payment';
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = 'UPI',           @Description = 'Unified Payments Interface';
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = 'Debit Card',    @Description = 'Bank debit card';
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = 'Bank Transfer', @Description = NULL; -- Description is optional

-- Failure: duplicate
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = 'Cash', @Description = 'Duplicate attempt';

-- Failure: missing required field
EXEC SP_PaymentMethodInsertUpdate @PaymentMethodName = NULL, @Description = 'No name';

-- Sanity check
SELECT * FROM PaymentMethod;


/* -------------------------------------------------------------------------
   7. TransactionType  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success
EXEC SP_TransactionTypeInsertUpdate @TransactionTypeName = 'Income',  @Description = 'Money coming in';
EXEC SP_TransactionTypeInsertUpdate @TransactionTypeName = 'Expense', @Description = 'Money going out';

-- Failure: duplicate
EXEC SP_TransactionTypeInsertUpdate @TransactionTypeName = 'Income', @Description = 'Duplicate attempt';

-- Failure: invalid domain value
EXEC SP_TransactionTypeInsertUpdate @TransactionTypeName = 'Transfer', @Description = 'Not allowed';

-- Failure: missing required field
EXEC SP_TransactionTypeInsertUpdate @TransactionTypeName = NULL, @Description = 'No name';

-- Sanity check
SELECT * FROM TransactionType;


/* -------------------------------------------------------------------------
   8. TransactionSource  (no dependencies)
   ------------------------------------------------------------------------- */

-- Success
EXEC SP_TransactionSourceInsertUpdate @TransactionSourceName = 'Manual';
EXEC SP_TransactionSourceInsertUpdate @TransactionSourceName = 'Import';
EXEC SP_TransactionSourceInsertUpdate @TransactionSourceName = 'Recurring';

-- Failure: duplicate
EXEC SP_TransactionSourceInsertUpdate @TransactionSourceName = 'Manual';

-- Failure: missing required field
EXEC SP_TransactionSourceInsertUpdate @TransactionSourceName = NULL;

-- Sanity check
SELECT * FROM TransactionSource;

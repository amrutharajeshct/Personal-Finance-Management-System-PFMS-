CREATE TABLE Users(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(100) UNIQUE  NOT NULL,
    PasswordHash VARCHAR(256),
    IsActive BIT DEFAULT 1  NOT NULL,
	LastLogin DATETIME ,
    CreatedAt DATETIME  NOT NULL,
    UpdatedAt DATETIME
);

CREATE TABLE UsersDetails (
    UserID INT PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    MobileNumber VARCHAR(15) UNIQUE NOT NULL,
    Address	VARCHAR(255),
    IsSalaried BIT ,
    Email VARCHAR(150) UNIQUE,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
	  FOREIGN KEY(UserID) REFERENCES Users(UserID)
);


CREATE TABLE AccountType(
    AccountTypeID INT IDENTITY(1,1) PRIMARY KEY,
    AccountTypeName	VARCHAR(50) UNIQUE,
    Description	VARCHAR(255),
    IsActive BIT DEFAULT 1,
	  CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Currency(
    CurrencyID INT IDENTITY(1,1) PRIMARY KEY,
    CurrencyCode VARCHAR(3) UNIQUE  NOT NULL,
    CurrencyName VARCHAR(50) NOT NULL,
    Symbol VARCHAR(5) ,
	  CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

CREATE TABLE Account(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    AccountName	VARCHAR(100) UNIQUE,
    AccountTypeID INT,
    CurrencyID INT,
    OpeningBalance DECIMAL(18,2),
    AccountNumber VARCHAR(30),
    IFSCCode VARCHAR(15),
    BankName VARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(AccountTypeID) REFERENCES AccountType(AccountTypeID),
	FOREIGN KEY(CurrencyID) REFERENCES Currency(CurrencyID)
);

CREATE TABLE CategoryType(
	CategoryTypeID INT IDENTITY(1,1) PRIMARY KEY,
	CategoryTypeName VARCHAR(10) UNIQUE,
	UpdatedAt DATETIME,
	IsActive BIT DEFAULT 1	
);

CREATE TABLE  Category(
CategoryID	INT	IDENTITY(1,1) PRIMARY KEY,
CategoryName VARCHAR(100) UNIQUE,
CategoryTypeID INT,
ParentCategoryID INT,
IsActive BIT DEFAULT 1,
CreatedAt DATETIME,
UpdatedAt DATETIME,
FOREIGN KEY(CategoryTypeID) REFERENCES CategoryType(CategoryTypeID)	
);

CREATE TABLE PaymentMethod(
	PaymentMethodID	INT	IDENTITY(1,1) PRIMARY KEY,
	PaymentMethodName VARCHAR(50) UNIQUE,
	Description	VARCHAR(255),
	IsActive BIT DEFAULT 1,
	UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE TransactionType(
	TransactionTypeID INT IDENTITY(1,1) PRIMARY KEY,
	TransactionTypeName	VARCHAR(10)	UNIQUE,
	Description	VARCHAR(255),
	IsActive BIT DEFAULT 1,
	UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE TransactionSource(
	TransactionSourceID	INT	IDENTITY(1,1) PRIMARY KEY,
	TransactionSourceName VARCHAR(50) UNIQUE,
	IsActive BIT DEFAULT 1,
	UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Transactions(
	TransactionID INT IDENTITY(1,1) PRIMARY KEY,
	AccountID INT,
	CategoryID INT,
	PaymentMethodID	INT,
	TransactionTypeID INT,
	TransactionSourceID	INT,
	Amount DECIMAL(18,2),
	TransactionDate	DATE,
	Description	VARCHAR(255),
	CreatedAt DATETIME,
	IsActive BIT DEFAULT 1,
	UpdatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (AccountID)	REFERENCES Account(AccountID),
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
	FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID),
	FOREIGN KEY (TransactionTypeID)	REFERENCES TransactionType(TransactionTypeID),
	FOREIGN KEY (TransactionSourceID)	REFERENCES TransactionSource(TransactionSourceID)
);

CREATE TABLE AccountTransfer(
	TransferID INT IDENTITY(1,1) PRIMARY KEY,
	FromAccountID INT,
	ToAccountID	INT,
	TransferDate DATE,		
	Amount DECIMAL(18,2),
	Description	VARCHAR(255),
	CreatedAt DATETIME,
	UpdatedAt DATETIME DEFAULT GETDATE(),
	IsActive BIT DEFAULT 1,
	FOREIGN KEY (FromAccountID)	REFERENCES Account(AccountID),
	FOREIGN KEY (ToAccountID)	REFERENCES Account(AccountID)
);




















CREATE TABLE Users(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(100) UNIQUE,
    PasswordHash VARCHAR(256),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME,
    UpdatedAt DATETIME
);

CREATE TABLE UsersDetails (
    UserID INT PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    MobileNumber VARCHAR(15) UNIQUE NOT NULL,
    Address	VARCHAR(255),
    IsSalaried BIT,
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
    CurrencyCode VARCHAR(3) UNIQUE,
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
    UpdatedAt DATETIME,,
    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(AccountTypeID) REFERENCES AccountType(AccountTypeID),
	FOREIGN KEY(CurrencyID) REFERENCES Currency(CurrencyID)
);




# Data Dictionary

## Introduction

This is a flat, searchable reference of every column in every PFMS table — useful for quickly looking up a single field without opening `08_Table_Specifications.md` and scanning per-table. For key relationships, constraints, and design rationale, see `08_Table_Specifications.md` and `07_Database_Design.md`.

---

| Table | Column | Data Type | Nullable | Key | Business Rule | Description |
|---|---|---|---|---|---|---|
| User | UserID | INT | No | PK | — | Unique identifier |
| User | UserName | VARCHAR(100) | No | UQ | BR-002 | Login name |
| User | PasswordHash | VARCHAR(256) | Yes | | BR-003 | Hashed password, once auth exists |
| User | IsActive | BIT | No | | — | Active/inactive flag |
| User | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| User | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |
| UserDetails | UserID | INT | No | PK, FK | — | Shared key with User |
| UserDetails | FullName | VARCHAR(150) | No | | BR-004 | User's full name |
| UserDetails | MobileNumber | VARCHAR(15) | No | UQ | BR-005 | Contact mobile number |
| UserDetails | Address | VARCHAR(255) | Yes | | BR-006 | Postal address |
| UserDetails | IsSalaried | BIT | No | | BR-007 | Whether user has a fixed salary |
| UserDetails | Email | VARCHAR(150) | Yes | UQ | BR-008 | Contact email |
| UserDetails | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| UserDetails | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |
| AccountType | AccountTypeID | INT | No | PK | — | Unique identifier |
| AccountType | AccountTypeName | VARCHAR(50) | No | UQ | BR-013 | Bank / Cash / Wallet / Savings |
| AccountType | Description | VARCHAR(255) | Yes | | — | Optional explanation |
| AccountType | IsActive | BIT | No | | — | Whether type is selectable |
| Currency | CurrencyID | INT | No | PK | — | Unique identifier |
| Currency | CurrencyCode | VARCHAR(3) | No | UQ | — | ISO-style code, e.g. "INR" |
| Currency | CurrencyName | VARCHAR(50) | No | | — | e.g. "Indian Rupee" |
| Currency | Symbol | VARCHAR(5) | No | | — | e.g. "₹" |
| Account | AccountID | INT | No | PK | — | Unique identifier |
| Account | UserID | INT | No | FK | BR-014 | Owning user |
| Account | AccountName | VARCHAR(100) | No | UQ | BR-009 | e.g. "Federal Bank" |
| Account | AccountTypeID | INT | No | FK | BR-013 | Type of account |
| Account | CurrencyID | INT | No | FK | — | Currency, defaults to INR |
| Account | OpeningBalance | DECIMAL(18,2) | No | | — | Initial balance |
| Account | AccountNumber | VARCHAR(30) | Yes | | — | NULL for Cash-type accounts |
| Account | IFSCCode | VARCHAR(15) | Yes | | — | NULL for Cash-type accounts |
| Account | BankName | VARCHAR(100) | Yes | | — | NULL for Cash-type accounts |
| Account | IsActive | BIT | No | | BR-010, BR-011 | Soft delete flag |
| Account | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| Account | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |
| CategoryType | CategoryTypeID | INT | No | PK | — | Unique identifier |
| CategoryType | CategoryTypeName | VARCHAR(10) | No | UQ | BR-015 | 'Income' or 'Expense' |
| Category | CategoryID | INT | No | PK | — | Unique identifier |
| Category | CategoryName | VARCHAR(100) | No | UQ (w/ type) | BR-016 | e.g. "Tea" |
| Category | CategoryTypeID | INT | No | FK | BR-015 | Income or Expense |
| Category | ParentCategoryID | INT | Yes | FK (self) | BR-019 | One level of hierarchy |
| Category | IsActive | BIT | No | | BR-018 | Soft delete flag |
| Category | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| Category | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |
| PaymentMethod | PaymentMethodID | INT | No | PK | — | Unique identifier |
| PaymentMethod | PaymentMethodName | VARCHAR(50) | No | UQ | BR-021 | Cash / UPI / Debit Card / Bank Transfer |
| PaymentMethod | Description | VARCHAR(255) | Yes | | — | Optional explanation |
| PaymentMethod | IsActive | BIT | No | | — | Whether method is selectable |
| TransactionType | TransactionTypeID | INT | No | PK | — | Unique identifier |
| TransactionType | TransactionTypeName | VARCHAR(10) | No | UQ | — | 'Income' or 'Expense' |
| TransactionSource | TransactionSourceID | INT | No | PK | — | Unique identifier |
| TransactionSource | TransactionSourceName | VARCHAR(50) | No | UQ | — | Manual / Import / Recurring |
| Transaction | TransactionID | INT | No | PK | — | Unique identifier |
| Transaction | AccountID | INT | No | FK | BR-012, BR-022 | Account the transaction belongs to |
| Transaction | CategoryID | INT | No | FK | BR-023 | Category the transaction belongs to |
| Transaction | PaymentMethodID | INT | No | FK | BR-027 | Payment method used |
| Transaction | TransactionTypeID | INT | No | FK | — | Income or Expense |
| Transaction | TransactionSourceID | INT | No | FK | — | Manual, Import, or Recurring |
| Transaction | Amount | DECIMAL(18,2) | No | | BR-024 | Must be > 0 |
| Transaction | TransactionDate | DATE | No | | BR-025 | Date of the transaction |
| Transaction | Description | VARCHAR(255) | Yes | | BR-026 | Optional note |
| Transaction | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| Transaction | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |
| AccountTransfer | TransferID | INT | No | PK | — | Unique identifier |
| AccountTransfer | FromAccountID | INT | No | FK | BR-029 | Source account |
| AccountTransfer | ToAccountID | INT | No | FK | BR-029 | Destination account |
| AccountTransfer | TransferDate | DATE | No | | — | Date of transfer |
| AccountTransfer | Amount | DECIMAL(18,2) | No | | BR-030 | Must be > 0 |
| AccountTransfer | Description | VARCHAR(255) | Yes | | — | Optional note |
| AccountTransfer | CreatedAt | DATETIME | No | | — | Row creation timestamp |
| AccountTransfer | UpdatedAt | DATETIME | Yes | | — | Last update timestamp |

---

## Quick Lookup: Business Rule → Column

| Business Rule | Enforced By |
|---|---|
| BR-002 (unique login) | `User.UserName` UNIQUE |
| BR-003 (password hashing) | `User.PasswordHash`, application-layer hashing |
| BR-004–BR-008 (profile fields) | `UserDetails` columns |
| BR-009 (unique account name) | `Account.AccountName` UNIQUE |
| BR-010, BR-011 (account soft delete) | `Account.IsActive`, no cascade delete |
| BR-012 (default account for unknown) | Seeded "Cash" row in `Account` |
| BR-013 (account type) | `Account.AccountTypeID` FK |
| BR-014 (multi-user ready) | `Account.UserID` FK |
| BR-015, BR-016 (category type/uniqueness) | `Category.CategoryTypeID`, `UQ_Category_NameType` |
| BR-017 (category delete block) | No cascade delete from `Transaction` |
| BR-018 (category soft delete) | `Category.IsActive` |
| BR-019, BR-020 (hierarchy + type match) | `Category.ParentCategoryID`, `trg_Category_ParentTypeMatch` |
| BR-021 (payment methods) | `PaymentMethod` lookup rows |
| BR-022–BR-027 (transaction fields) | `Transaction` table columns |
| BR-023 (type match) | `trg_Transaction_CategoryTypeMatch` |
| BR-024 (amount > 0) | `CK_Transaction_Amount` |
| BR-028–BR-033 (transfers) | `AccountTransfer` table + constraints |
| BR-041 (savings) | Derived in reporting layer — no stored column |
| BR-042–BR-046 (data integrity) | PK/FK constraints, `DECIMAL` type, soft deletes throughout |

---

Next document: **10_Normalization.md** — explaining how this schema satisfies 1NF, 2NF, and 3NF.

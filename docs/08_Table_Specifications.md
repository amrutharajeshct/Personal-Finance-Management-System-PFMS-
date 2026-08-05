# Table Specifications

## Introduction

This document is the authoritative, column-by-column specification for every table in the PFMS database. It reflects exactly what `01_create_tables.sql` implements. Where `05_Entity_Analysis.md` was the design proposal, this document is the as-built reference.

---

## 1. User

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| UserID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| UserName | VARCHAR(100) | No | UQ | — | Login name (BR-002) |
| PasswordHash | VARCHAR(256) | Yes | | NULL | Populated once authentication is introduced (BR-003) |
| IsActive | BIT | No | | 1 | Active/inactive flag |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

---

## 2. UserDetails

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| UserID | INT | No | PK, FK → User | — | Shared PK/FK; 1:1 with User |
| FullName | VARCHAR(150) | No | | — | BR-004 |
| MobileNumber | VARCHAR(15) | No | UQ | — | BR-005 |
| Address | VARCHAR(255) | Yes | | NULL | BR-006 |
| IsSalaried | BIT | No | | — | BR-007 |
| Email | VARCHAR(150) | Yes | UQ | NULL | BR-008 |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

---

## 3. AccountType *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| AccountTypeID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| AccountTypeName | VARCHAR(50) | No | UQ | — | Bank / Cash / Wallet / Savings (BR-013) |
| Description | VARCHAR(255) | Yes | | NULL | Optional explanation |
| IsActive | BIT | No | | 1 | Allows retiring a type |

---

## 4. Currency *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| CurrencyID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| CurrencyCode | VARCHAR(3) | No | UQ | — | e.g., "INR" |
| CurrencyName | VARCHAR(50) | No | | — | e.g., "Indian Rupee" |
| Symbol | VARCHAR(5) | No | | — | e.g., "₹" |

---

## 5. Account

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| AccountID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| UserID | INT | No | FK → User | — | BR-014 |
| AccountName | VARCHAR(100) | No | UQ | — | BR-009 |
| AccountTypeID | INT | No | FK → AccountType | — | BR-013 |
| CurrencyID | INT | No | FK → Currency | INR row | Defaults to INR in V1 |
| OpeningBalance | DECIMAL(18,2) | No | | 0 | Initial balance |
| AccountNumber | VARCHAR(30) | Yes | | NULL | NULL for Cash-type accounts |
| IFSCCode | VARCHAR(15) | Yes | | NULL | NULL for Cash-type accounts |
| BankName | VARCHAR(100) | Yes | | NULL | NULL for Cash-type accounts |
| IsActive | BIT | No | | 1 | BR-010, BR-011 |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

**No `CurrentBalance` column** — always derived: `OpeningBalance + Income − Expense + Incoming Transfers − Outgoing Transfers`.

---

## 6. CategoryType *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| CategoryTypeID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| CategoryTypeName | VARCHAR(10) | No | UQ | — | 'Income' or 'Expense' (CHECK-constrained) |

---

## 7. Category

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| CategoryID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| CategoryName | VARCHAR(100) | No | UQ (with CategoryTypeID) | — | BR-016 |
| CategoryTypeID | INT | No | FK → CategoryType | — | BR-015 |
| ParentCategoryID | INT | Yes | FK → Category (self) | NULL | One level only (BR-019) |
| IsActive | BIT | No | | 1 | BR-018 |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

**Trigger:** `trg_Category_ParentTypeMatch` enforces BR-020 (child type must match parent type).

---

## 8. PaymentMethod *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| PaymentMethodID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| PaymentMethodName | VARCHAR(50) | No | UQ | — | Cash / UPI / Debit Card / Bank Transfer (BR-021) |
| Description | VARCHAR(255) | Yes | | NULL | Optional explanation |
| IsActive | BIT | No | | 1 | Allows retiring a method |

---

## 9. TransactionType *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| TransactionTypeID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| TransactionTypeName | VARCHAR(10) | No | UQ | — | 'Income' or 'Expense' (CHECK-constrained) |

---

## 10. TransactionSource *(lookup)*

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| TransactionSourceID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| TransactionSourceName | VARCHAR(50) | No | UQ | — | Manual / Import / Recurring |

---

## 11. Transaction

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| TransactionID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| AccountID | INT | No | FK → Account | — | BR-012, BR-022 |
| CategoryID | INT | No | FK → Category | — | BR-023 |
| PaymentMethodID | INT | No | FK → PaymentMethod | — | BR-027 |
| TransactionTypeID | INT | No | FK → TransactionType | — | Replaces free-text type |
| TransactionSourceID | INT | No | FK → TransactionSource | "Manual" row | Defaults to Manual in V1 |
| Amount | DECIMAL(18,2) | No | | — | Must be > 0 (BR-024) |
| TransactionDate | DATE | No | | — | BR-025 |
| Description | VARCHAR(255) | Yes | | NULL | BR-026 |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

**Trigger:** `trg_Transaction_CategoryTypeMatch` enforces BR-023 (transaction type must match category type, compared by name across the two independent lookups).

---

## 12. AccountTransfer

| Column | Data Type | Nullable | Key | Default | Description |
|---|---|---|---|---|---|
| TransferID | INT | No | PK | IDENTITY(1,1) | Unique identifier |
| FromAccountID | INT | No | FK → Account | — | Must differ from ToAccountID (BR-029) |
| ToAccountID | INT | No | FK → Account | — | |
| TransferDate | DATE | No | | — | |
| Amount | DECIMAL(18,2) | No | | — | Must be > 0 (BR-030) |
| Description | VARCHAR(255) | Yes | | NULL | Optional |
| CreatedAt | DATETIME | No | | GETDATE() | Audit column |
| UpdatedAt | DATETIME | Yes | | NULL | Audit column |

---

Next document: **09_Data_Dictionary.md** — a flattened, searchable reference of every column across every table.
